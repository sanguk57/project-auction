package com.myauct.web.domain.auctmaster.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctmaster.dao.AuctFileUploadDAO;
import com.myauct.web.domain.auctmaster.dao.AuctMasterDAO;
import com.myauct.web.domain.auctmaster.dao.AuctMasterJoinDAO;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;
import com.myauct.web.global.AuctionTime;
import com.myauct.web.global.BusinessException;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class AuctMasterServiceImp implements AuctMasterService {

	private static final Logger logger = LoggerFactory.getLogger(AuctMasterServiceImp.class);

	private final AuctMasterDAO auctMasterDAO;
	private final AuctMasterJoinDAO auctMasterJoinDAO;
	private final AuctFileUploadDAO auctFileUploadDAO;
	private final AuctCategoryService auctCategoryService;
	private final FileStorageService fileStorage;

	@Override
	public List<AuctMasterDTO> getProductList(PagingDTO pagingDTO) {
		return auctMasterDAO.getProductList(pagingDTO);
	}

	@Override
	public AuctMasterDTO getProduct(int anum) {
		AuctMasterDTO dto = auctMasterDAO.getProduct(anum);
		if (dto == null) {
			throw new BusinessException(HttpStatus.NOT_FOUND, "존재하지 않는 상품입니다.");
		}
		return dto;
	}

	@Override
	public int getProductCnt(String value) {
		return auctMasterDAO.getProductCnt(value);
	}

	@Override
	public int getUserProductCnt(int unum) {
		return auctMasterDAO.getUserProductCnt(unum);
	}

	private static final int SUGGEST_LIMIT = 8;
	private static final int SUGGEST_MAX_LENGTH = 30;

	@Override
	public List<SuggestDTO> suggest(String keyword) {
		String q = keyword == null ? "" : keyword.trim();
		if (q.isEmpty() || q.length() > SUGGEST_MAX_LENGTH) {
			return new ArrayList<>();
		}
		// "%" 나 "_" 를 입력하면 LIKE 에서 '모든 글자' 로 해석되므로 글자 그대로 찾도록 이스케이프
		String escaped = q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		return auctMasterDAO.suggest(escaped, SUGGEST_LIMIT);
	}

	@Override
	@Transactional
	public int registerProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] files,
			int loginUnum) {
		validateProduct(product);
		fileStorage.validate(files); // DB 에 넣기 전에 파일부터 검사

		product.setUnum(loginUnum); // 화면에서 넘어온 unum(hidden) 은 조작할 수 있으므로 무시
		product.setCnum(auctCategoryService.resolveCnum(category));
		auctMasterDAO.createProduct(product);

		saveFiles(product.getAnum(), files);
		return product.getAnum();
	}

	@Override
	@Transactional
	public void modifyProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] files,
			int loginUnum) {
		AuctMasterDTO saved = getEditableProduct(product.getAnum(), loginUnum);
		validateProduct(product);
		fileStorage.validate(files);

		product.setUnum(saved.getUnum());
		product.setCnum(auctCategoryService.resolveCnum(category));
		auctMasterDAO.modifyProduct(product);

		// 새 이미지를 올렸을 때만 기존 이미지를 교체
		if (FileStorageService.hasFile(files)) {
			deleteFiles(product.getAnum());
			saveFiles(product.getAnum(), files);
		}
	}

	@Override
	@Transactional
	public void deleteProduct(int anum, int loginUnum) {
		getEditableProduct(anum, loginUnum);
		deleteFiles(anum);
		auctMasterDAO.deleteProduct(anum);
	}

	@Override
	@Transactional
	public void bid(int anum, int loginUnum, int bidAmt, int amount) {
		AuctMasterDTO product = getProduct(anum);

		if (product.getUnum() == loginUnum) {
			throw BusinessException.badRequest("본인이 등록한 상품에는 입찰할 수 없습니다.");
		}
		checkAuctionPeriod(product);
		if (amount < 1 || amount > product.getTotal_cnt()) {
			throw BusinessException.badRequest("입찰 수량을 확인해주세요.");
		}
		int minBid = product.getMin_bid();
		if (bidAmt < minBid) {
			throw BusinessException.badRequest(String.format("%,d원 이상으로 입찰해주세요.", minBid));
		}

		// 내가 화면을 보고 있는 동안 다른 사람이 먼저 입찰했으면 실패
		Integer updated = auctMasterDAO.updateBidAmt(anum, product.getStart_amt(), bidAmt);
		if (updated == null || updated == 0) {
			throw new BusinessException(HttpStatus.CONFLICT, "다른 사람이 먼저 입찰했습니다. 새로고침 후 다시 시도해주세요.");
		}

		AuctMasterJoinDTO join = new AuctMasterJoinDTO();
		join.setAnum(anum);
		join.setUnum(loginUnum);
		join.setVolume(bidAmt);
		join.setAmount(amount);
		auctMasterJoinDAO.auctionApplicant(join);
	}

	@Override
	public List<String> getImagePaths(int anum) {
		List<String> paths = new ArrayList<>();
		for (AuctFileUploadDTO dto : auctFileUploadDAO.fileList(anum)) {
			paths.add(FileStorageService.urlPath(dto, false));
		}
		return paths;
	}

	@Override
	public Map<String, List<String>> getThumbnailPaths(List<Integer> anums) {
		// 예전: 모든 상품이 리스트 하나를 같이 써서, 뒤 상품에 앞 상품 이미지까지 섞여 나왔음
		Map<String, List<String>> result = new LinkedHashMap<>();
		if (anums == null || anums.isEmpty()) {
			return result;
		}
		for (AuctFileUploadDTO dto : auctFileUploadDAO.fileListByAnums(anums)) {
			result.computeIfAbsent(String.valueOf(dto.getAnum()), k -> new ArrayList<>())
					.add(FileStorageService.urlPath(dto, true));
		}
		return result;
	}

	// ---------------------------------------------------------------------

	private AuctMasterDTO getEditableProduct(int anum, int loginUnum) {
		AuctMasterDTO saved = getProduct(anum);
		if (saved.getUnum() != loginUnum) {
			throw BusinessException.forbidden();
		}
		if (saved.getJoin_cnt() > 0) {
			throw BusinessException.badRequest("입찰이 시작된 상품은 수정하거나 삭제할 수 없습니다.");
		}
		return saved;
	}

	private void validateProduct(AuctMasterDTO p) {
		// 선택하지 않은 항목은 null → NOT NULL 컬럼 오류가 나므로 기본값, Y/N 이외 값은 거부
		p.setProd_type(yn(p.getProd_type(), "N", "상품 상태"));
		p.setAs_type(yn(p.getAs_type(), "N", "AS 여부"));
		p.setLimit_type(yn(p.getLimit_type(), "N", "즉시구매 여부"));
		p.setTrans_type(yn(p.getTrans_type(), "Y", "거래 방식"));
		if ("N".equals(p.getLimit_type())) {
			p.setLimit_amt(0);
		}
		if (isBlank(p.getProd_title()) || isBlank(p.getProd_name())) {
			throw BusinessException.badRequest("상품 제목과 상품명을 입력해주세요.");
		}
		if (p.getStart_amt() <= 0) {
			throw BusinessException.badRequest("시작 가격을 입력해주세요.");
		}
		if (p.getTotal_cnt() < 1) {
			throw BusinessException.badRequest("판매 수량은 1개 이상이어야 합니다.");
		}
		if (p.getJoin_amt() < 0 || p.getLimit_amt() < 0 || p.getCurr_amt() < 0) {
			throw BusinessException.badRequest("금액은 0 이상이어야 합니다.");
		}
		LocalDateTime start = AuctionTime.parse(p.getAuct_start());
		LocalDateTime end = AuctionTime.parse(p.getAuct_end());
		if (start == null || end == null || !start.isBefore(end)) {
			throw BusinessException.badRequest("경매 시작/종료 날짜를 확인해주세요.");
		}
	}

	private void checkAuctionPeriod(AuctMasterDTO product) {
		LocalDateTime start = AuctionTime.parse(product.getAuct_start());
		LocalDateTime end = AuctionTime.parse(product.getAuct_end());
		if (start == null || end == null) {
			logger.warn("경매 기간을 읽을 수 없음 anum={}, start={}, end={}", product.getAnum(),
					product.getAuct_start(), product.getAuct_end());
			return;
		}
		LocalDateTime now = LocalDateTime.now();
		if (now.isBefore(start)) {
			throw BusinessException.badRequest("아직 경매가 시작되지 않았습니다.");
		}
		if (now.isAfter(end)) {
			throw BusinessException.badRequest("경매가 마감되었습니다.");
		}
	}

	private void saveFiles(int anum, MultipartFile[] files) {
		List<AuctFileUploadDTO> stored = fileStorage.store(anum, files);
		// DB 저장이 실패해서 롤백되면 방금 저장한 파일도 지운다
		afterRollback(() -> stored.forEach(fileStorage::delete));
		for (AuctFileUploadDTO dto : stored) {
			auctFileUploadDAO.fileUpload(dto);
		}
	}

	private void deleteFiles(int anum) {
		List<AuctFileUploadDTO> old = auctFileUploadDAO.fileList(anum);
		auctFileUploadDAO.deleteFile(anum);
		// 실제 파일은 DB 반영(커밋)이 끝난 뒤에 지운다
		afterCommit(() -> old.forEach(fileStorage::delete));
	}

	private static void afterCommit(Runnable task) {
		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCommit() {
				task.run();
			}
		});
	}

	private static void afterRollback(Runnable task) {
		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCompletion(int status) {
				if (status == STATUS_ROLLED_BACK) {
					task.run();
				}
			}
		});
	}

	private static String yn(String value, String defaultValue, String label) {
		if (isBlank(value)) {
			return defaultValue;
		}
		if (!"Y".equals(value) && !"N".equals(value)) {
			throw BusinessException.badRequest(label + " 값이 올바르지 않습니다.");
		}
		return value;
	}

	private static boolean isBlank(String s) {
		return s == null || s.trim().isEmpty();
	}
}
