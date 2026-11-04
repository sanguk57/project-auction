package com.myauct.web.domain.auctconcern.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctconcern.dao.AuctConcernDAO;
import com.myauct.web.domain.auctconcern.dto.AuctConcernDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctConcernServiceImp implements AuctConcernService {

	private final AuctConcernDAO auctConcernDAO;

	@Override
	public void addConcern(int anum, int unum) {
		Integer exists = auctConcernDAO.existsConcern(anum, unum);
		if (exists == null || exists == 0) {
			auctConcernDAO.createConcern(anum, unum);
		}
	}

	@Override
	public void removeConcern(int anum, int unum) {
		auctConcernDAO.deleteConcern(anum, unum);
	}

	@Override
	public List<Integer> concernAnumList(int unum) {
		return auctConcernDAO.concernList(unum).stream().map(AuctConcernDTO::getAnum).collect(Collectors.toList());
	}

	@Override
	public int concernCnt(int unum) {
		return auctConcernDAO.concernCnt(unum);
	}
}
