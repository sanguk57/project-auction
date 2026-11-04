package com.myauct.web.unit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.file.Path;
import java.util.List;

import javax.imageio.ImageIO;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.service.FileStorageService;
import com.myauct.web.global.BusinessException;

/** DB 없이 실행되는 단위 테스트 */
class FileStorageServiceTest {

	@TempDir
	Path tmp;

	private static byte[] png() throws Exception {
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		ImageIO.write(new BufferedImage(30, 30, BufferedImage.TYPE_INT_RGB), "png", out);
		return out.toByteArray();
	}

	private static MultipartFile file(String name, byte[] content) {
		return new MockMultipartFile("uploadFile", name, "application/octet-stream", content);
	}

	@Test
	void rejectsJsp() {
		FileStorageService s = new FileStorageService(tmp.toString());
		MultipartFile[] files = { file("shell.jsp", "<% out.println(1); %>".getBytes()) };
		assertThrows(BusinessException.class, () -> s.store(1, files));
	}

	@Test
	void rejectsFakeImage() {
		FileStorageService s = new FileStorageService(tmp.toString());
		MultipartFile[] files = { file("a.png", "not an image".getBytes()) };
		assertThrows(BusinessException.class, () -> s.store(1, files));
	}

	@Test
	void storesImageAndThumbnailThenDeletes() throws Exception {
		FileStorageService s = new FileStorageService(tmp.toString());
		List<AuctFileUploadDTO> saved = s.store(7, new MultipartFile[] {
				file("../../사진 1.PNG", png()),
				file("", new byte[0]) }); // 비어 있는 파일 칸은 무시

		assertEquals(1, saved.size());
		AuctFileUploadDTO dto = saved.get(0);
		assertEquals(".png", dto.getFile_ext());
		assertFalse(dto.getFile_name().contains(".."), "경로 이동 문자는 제거");
		assertFalse(FileStorageService.urlPath(dto, false).contains("\\"), "URL 경로는 / 로 구분");

		File original = tmp.resolve(FileStorageService.urlPath(dto, false)).toFile();
		File thumb = tmp.resolve(FileStorageService.urlPath(dto, true)).toFile();
		assertTrue(original.exists());
		assertTrue(thumb.exists());

		s.delete(dto);
		assertFalse(original.exists());
		assertFalse(thumb.exists());
	}
}
