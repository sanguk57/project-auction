package com.myauct.web.domain.auctmaster.dao;

import java.util.List;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;

public interface AuctFileUploadDAO {
	Integer fileUpload(AuctFileUploadDTO auctFileUploadDTO);
	
	Integer modifyFile(AuctFileUploadDTO auctFileUploadDTO);
	
	List<AuctFileUploadDTO> fileList(int anum);
	
	AuctFileUploadDTO getUploadFile(int fnum);
}
