package com.myauct.web.domain.auctconcern.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctconcern.dto.AuctConcernDTO;

public interface AuctConcernDAO {
	Integer createConcern(@Param("anum") int anum, @Param("unum") int unum);

	Integer deleteConcern(@Param("anum") int anum, @Param("unum") int unum);

	Integer existsConcern(@Param("anum") int anum, @Param("unum") int unum);

	List<AuctConcernDTO> concernList(int unum);

	Integer concernCnt(int unum);
}
