package com.myauct.web.domain.auctmaster.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

public interface AuctMasterService {

	List<AuctMasterDTO> getProductList(PagingDTO pagingDTO);

	/** getProductList 와 같은 조건(검색 · 상태 · 카테고리 · 내 상품 · 관심 상품)의 개수 */
	int countProductList(PagingDTO filter);

	/** 없는 상품이면 BusinessException. 마감 시간이 지났으면 이 자리에서 낙찰/유찰 처리 후 돌려준다 */
	AuctMasterDTO getProduct(int anum);

	int getProductCnt(String value);

	int getUserProductCnt(int unum);

	/** 검색 자동완성 (검색어가 비었거나 너무 길면 빈 목록) */
	List<SuggestDTO> suggest(String keyword);

	/** 상품 + 이미지 등록, 새 상품 번호 반환 */
	int registerProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] files, int loginUnum);

	/**
	 * 본인 상품이고 아직 입찰이 없을 때만 수정.
	 * @param newFiles    새로 추가할 사진 (기존 사진 뒤에 붙는다)
	 * @param deleteFnums 삭제할 기존 사진 번호
	 * @param mainFnum    대표 사진으로 정할 기존 사진 번호 (null 이면 그대로)
	 */
	void modifyProduct(AuctMasterDTO product, AuctCategoryDTO category, MultipartFile[] newFiles, int loginUnum,
			List<Integer> deleteFnums, Integer mainFnum);

	/** 본인 상품이고 아직 입찰이 없을 때만 삭제 */
	void deleteProduct(int anum, int loginUnum);

	/**
	 * 입찰.
	 * @param bidAmt 입찰가
	 * @param amount 수량
	 */
	void bid(int anum, int loginUnum, int bidAmt, int amount);

	/** 즉시구매: 즉시구매가로 바로 낙찰되고 경매가 끝난다 */
	void buyNow(int anum, int loginUnum, int amount);

	/** 지금 최고 입찰자 회원번호 (입찰이 없으면 null) */
	Integer getTopBidderUnum(int anum);

	/** 상세 · 수정 화면용 사진 (sort_no 순서) */
	List<AuctFileUploadDTO> getPhotos(int anum);

	/** 상세화면용 원본 이미지 경로 목록 */
	List<String> getImagePaths(int anum);

	/** 목록화면용: 상품번호 → 썸네일 경로 목록 */
	Map<String, List<String>> getThumbnailPaths(List<Integer> anums);
}
