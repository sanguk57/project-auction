package com.myauct.web.domain.auctmaster.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

public interface AuctMasterService {

	List<AuctMasterDTO> getProductList(PagingDTO pagingDTO);

	/** 없는 상품이면 BusinessException */
	AuctMasterDTO getProduct(int anum);

	int getProductCnt(String value);

	int getUserProductCnt(int unum);

	/** 검색 자동완성 (검색어가 비었거나 너무 길면 빈 목록) */
	List<SuggestDTO> suggest(String keyword);

	/** 상품 + 이미지 등록, 새 상품 번호 반환 */
	int registerProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] files, int loginUnum);

	/** 본인 상품이고 아직 입찰이 없을 때만 수정 */
	void modifyProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] files, int loginUnum);

	/** 본인 상품이고 아직 입찰이 없을 때만 삭제 */
	void deleteProduct(int anum, int loginUnum);

	/**
	 * 입찰.
	 * @param bidAmt 입찰가
	 * @param amount 수량
	 */
	void bid(int anum, int loginUnum, int bidAmt, int amount);

	/** 상세화면용 원본 이미지 경로 목록 */
	List<String> getImagePaths(int anum);

	/** 목록화면용: 상품번호 → 썸네일 경로 목록 */
	Map<String, List<String>> getThumbnailPaths(List<Integer> anums);
}
