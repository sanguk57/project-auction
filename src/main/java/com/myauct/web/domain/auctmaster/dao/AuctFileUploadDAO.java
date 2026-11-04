package com.myauct.web.domain.auctmaster.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;

public interface AuctFileUploadDAO {
	Integer fileUpload(AuctFileUploadDTO auctFileUploadDTO);

	/** 상품의 사진 (sort_no 순서, 첫 번째가 대표) */
	List<AuctFileUploadDTO> fileList(int anum);

	/** 여러 상품의 이미지를 한 번에 조회 (상품마다 쿼리를 날리지 않도록) */
	List<AuctFileUploadDTO> fileListByAnums(@Param("anums") List<Integer> anums);

	/** 지금 가장 큰 sort_no (사진이 없으면 -1) */
	int maxSortNo(int anum);

	/** 지금 가장 작은 sort_no (사진이 없으면 0) */
	int minSortNo(int anum);

	Integer updateSortNo(@Param("fnum") int fnum, @Param("anum") int anum, @Param("sortNo") int sortNo);

	/** 고른 사진만 삭제 (다른 상품의 사진 번호를 보내도 지워지지 않도록 anum 도 확인) */
	Integer deleteFiles(@Param("anum") int anum, @Param("fnums") List<Integer> fnums);

	Integer deleteFile(int anum);
}
