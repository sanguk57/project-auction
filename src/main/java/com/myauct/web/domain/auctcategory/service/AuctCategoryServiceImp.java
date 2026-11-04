package com.myauct.web.domain.auctcategory.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctcategory.dao.AuctCategoryDAO;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.global.BusinessException;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctCategoryServiceImp implements AuctCategoryService {

	private final AuctCategoryDAO auctCategoryDAO;

	@Override
	public int resolveCnum(AuctCategoryDTO categoryDTO) {
		if (categoryDTO.getCnum() != 0) {
			return categoryDTO.getCnum();
		}
		String name = categoryDTO.getCategory() == null ? "" : categoryDTO.getCategory().trim();
		if (name.isEmpty()) {
			throw BusinessException.badRequest("카테고리를 입력해주세요.");
		}
		Integer existing = auctCategoryDAO.getCnum(name);
		if (existing != null) {
			return existing;
		}
		AuctCategoryDTO created = new AuctCategoryDTO();
		created.setCategory(name);
		auctCategoryDAO.registerCategory(created);
		return created.getCnum();
	}

	@Override
	public List<AuctCategoryDTO> getCategoryList() {
		return auctCategoryDAO.getCategoryList();
	}

	@Override
	public String getCategory(int cnum) {
		return auctCategoryDAO.getCategory(cnum);
	}
}
