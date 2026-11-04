package com.myauct.web.auction;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;
import java.util.stream.Collectors;

import javax.imageio.ImageIO;
import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.support.TestDb;

/** 상품 수정 시 사진 한 장씩 삭제 · 추가 · 대표 사진 지정 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
class PhotoManagementTest {

	@Autowired DataSource dataSource;
	@Autowired AuctMasterService service;

	@BeforeEach
	void reset() {
		TestDb.reset(dataSource);
	}

	private static MultipartFile png(String name) throws Exception {
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		ImageIO.write(new BufferedImage(40, 30, BufferedImage.TYPE_INT_RGB), "png", out);
		return new MockMultipartFile("uploadFile", name, "image/png", out.toByteArray());
	}

	private static AuctMasterDTO product(String title) {
		AuctMasterDTO p = new AuctMasterDTO();
		p.setProd_title(title);
		p.setProd_name(title);
		p.setStart_amt(10_000);
		p.setJoin_amt(1_000);
		p.setTotal_cnt(1);
		p.setAuct_start("2030-01-01 10:00");
		p.setAuct_end("2030-01-08 10:00");
		return p;
	}

	private static AuctCategoryDTO category(int cnum) {
		AuctCategoryDTO c = new AuctCategoryDTO();
		c.setCnum(cnum);
		return c;
	}

	private List<String> names(int anum) {
		return service.getPhotos(anum).stream().map(AuctFileUploadDTO::getFile_name).collect(Collectors.toList());
	}

	@Test
	void deleteAddAndChooseMainPhoto() throws Exception {
		int anum = service.registerProduct(product("사진테스트"), category(1),
				new MultipartFile[] { png("a.png"), png("b.png"), png("c.png") }, 1);
		assertEquals(List.of("a", "b", "c"), names(anum), "고른 순서대로 저장");

		List<AuctFileUploadDTO> photos = service.getPhotos(anum);
		int fnumA = photos.get(0).getFnum(), fnumC = photos.get(2).getFnum();

		// a 삭제, d 추가, c 를 대표로
		AuctMasterDTO edit = product("사진테스트");
		edit.setAnum(anum);
		service.modifyProduct(edit, category(1), new MultipartFile[] { png("d.png") }, 1, List.of(fnumA), fnumC);

		assertEquals(List.of("c", "b", "d"), names(anum), "대표(c)가 맨 앞, 새 사진(d)은 뒤에");
		String thumb = service.getProductList(new com.myauct.web.domain.user.service.global.util.PagingDTO(1, 1, 50, "사진테스트", null, 0))
				.get(0).getThumb();
		assertTrue(thumb.contains("/s_c_"), "목록 썸네일도 대표 사진");

		File deleted = new File("target/test-upload", photos.get(0).getUrl());
		assertTrue(!deleted.exists(), "삭제한 사진 파일도 지워짐");
	}

	@Test
	void cannotDeleteOtherProductsPhotos() throws Exception {
		int mine = service.registerProduct(product("내상품"), category(1), new MultipartFile[] { png("x.png") }, 1);
		int other = service.registerProduct(product("남상품"), category(1), new MultipartFile[] { png("y.png") }, 1);
		int otherFnum = service.getPhotos(other).get(0).getFnum();

		AuctMasterDTO edit = product("내상품");
		edit.setAnum(mine);
		service.modifyProduct(edit, category(1), null, 1, List.of(otherFnum), null);
		assertEquals(1, service.getPhotos(other).size(), "다른 상품의 사진 번호를 보내도 지워지지 않음");
	}
}
