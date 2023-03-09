package com.myauct.web.domain.auctmaster.service;

import java.util.List;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;

public interface AuctFileUploadService {
	Integer fileUpload(AuctFileUploadDTO auctFileUploadDTO);
	
	Integer modifyFile(AuctFileUploadDTO auctFileUploadDTO);
	
	List<AuctFileUploadDTO> fileList(int anum);
	
	AuctFileUploadDTO getUploadFile(int fnum);
	
	Integer deleteFile(int anum);
}
