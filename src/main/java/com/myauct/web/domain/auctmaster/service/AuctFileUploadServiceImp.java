package com.myauct.web.domain.auctmaster.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctmaster.dao.AuctFileUploadDAO;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctFileUploadServiceImp  implements AuctFileUploadService{
	
	final private AuctFileUploadDAO auctFileUploadDAO;
	
	@Override
	public Integer fileUpload(AuctFileUploadDTO auctFileUploadDTO) {
		return auctFileUploadDAO.fileUpload(auctFileUploadDTO);
	}

	@Override
	public Integer modifyFile(AuctFileUploadDTO auctFileUploadDTO) {
		return auctFileUploadDAO.modifyFile(auctFileUploadDTO);
	}

	@Override
	public AuctFileUploadDTO getUploadFile(int fnum) {
		return auctFileUploadDAO.getUploadFile(fnum);
	}

	@Override
	public List<AuctFileUploadDTO> fileList(int anum) {
		return auctFileUploadDAO.fileList(anum);
	}



}
