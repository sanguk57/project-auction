package com.myauct.web.domain.auctmaster.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;

public interface AuctFileUploadDAO {
	Integer fileUpload(AuctFileUploadDTO auctFileUploadDTO);

	List<AuctFileUploadDTO> fileList(int anum);

	/** 여러 상품의 이미지를 한 번에 조회 (상품마다 쿼리를 날리지 않도록) */
	List<AuctFileUploadDTO> fileListByAnums(@Param("anums") List<Integer> anums);

	Integer deleteFile(int anum);
}
