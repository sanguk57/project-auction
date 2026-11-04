package com.myauct.web.domain.auctmaster.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.global.BusinessException;

import net.coobird.thumbnailator.Thumbnails;

/**
 * 상품 이미지 저장/삭제.
 *
 * 고친 점
 *  - 저장 폴더가 특정 맥북 경로(/Users/Kungas_57/...)로 하드코딩 → app.properties 의 upload.path
 *  - 삭제할 때는 또 다른 경로(/kuk2028/tomcat/...)를 써서 실제 파일이 안 지워졌음 → 같은 경로 사용
 *  - 확장자 검사가 없어서 .jsp 같은 파일도 올릴 수 있었음(웹셸 업로드 → 서버 장악 가능) → 이미지만 허용
 *  - 확장자 없는 파일이면 StringIndexOutOfBoundsException, 이미지가 아니면 NullPointerException
 *  - 윈도우에서는 경로 구분자가 '\' 로 저장돼서 이미지 URL 이 깨짐 → DB 에는 항상 '/' 로 저장
 */
@Service
public class FileStorageService {

	private static final Logger logger = LoggerFactory.getLogger(FileStorageService.class);

	private static final List<String> ALLOWED_EXT = Arrays.asList(".jpg", ".jpeg", ".png", ".gif");
	private static final DateTimeFormatter DATE_PATH = DateTimeFormatter.ofPattern("yyyy/MM/dd");
	private static final DateTimeFormatter STAMP = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmssSSS");
	/** 썸네일 긴 쪽 최대 크기(px). 예전: 원본의 1/3 → 카드에서 사진이 흐리게 보였음 */
	private static final int THUMBNAIL_MAX = 640;

	private final File rootDir;

	public FileStorageService(@Value("${upload.path}") String uploadPath) {
		this.rootDir = new File(uploadPath);
	}

	/** 비어 있지 않은 파일이 하나라도 있는지 */
	public static boolean hasFile(MultipartFile[] files) {
		if (files == null) {
			return false;
		}
		for (MultipartFile f : files) {
			if (f != null && !f.isEmpty()) {
				return true;
			}
		}
		return false;
	}

	/** 저장하기 전에 모든 파일이 이미지인지 먼저 검사 (일부만 저장되는 것 방지) */
	public void validate(MultipartFile[] files) {
		if (files == null) {
			return;
		}
		for (MultipartFile f : files) {
			if (f == null || f.isEmpty()) {
				continue;
			}
			String ext = extensionOf(f.getOriginalFilename());
			if (!ALLOWED_EXT.contains(ext)) {
				throw BusinessException.badRequest("이미지 파일(jpg, png, gif)만 올릴 수 있습니다.");
			}
		}
	}

	/** 파일을 저장하고, DB 에 넣을 정보 목록을 돌려준다. */
	public List<AuctFileUploadDTO> store(int anum, MultipartFile[] files) {
		validate(files);
		List<AuctFileUploadDTO> result = new ArrayList<>();
		if (files == null) {
			return result;
		}

		String datePath = LocalDate.now().format(DATE_PATH);
		File dir = new File(rootDir, datePath);
		if (!dir.exists() && !dir.mkdirs()) {
			throw new IllegalStateException("업로드 폴더를 만들 수 없습니다: " + dir);
		}

		for (MultipartFile f : files) {
			if (f == null || f.isEmpty()) {
				continue;
			}
			String original = new File(f.getOriginalFilename()).getName(); // 경로 부분 제거
			String ext = extensionOf(original);
			String baseName = sanitize(original.substring(0, original.length() - ext.length()));
			// 같은 시간에 올려도 겹치지 않도록 랜덤값 추가
			String dname = LocalDateTime.now().format(STAMP) + "_" + UUID.randomUUID().toString().substring(0, 8);

			AuctFileUploadDTO dto = new AuctFileUploadDTO();
			dto.setAnum(anum);
			dto.setUpload_path(datePath);
			dto.setFile_name(baseName);
			dto.setFile_dname(dname);
			dto.setFile_ext(ext);

			File saveFile = new File(dir, fileName(dto, false));
			try {
				f.transferTo(saveFile);
				BufferedImage image = ImageIO.read(saveFile);
				if (image == null) { // 확장자만 이미지이고 내용은 이미지가 아닌 경우
					Files.deleteIfExists(saveFile.toPath());
					throw BusinessException.badRequest("이미지 파일이 아닙니다: " + original);
				}
				// 작은 사진은 키우지 않고 그대로, 큰 사진은 긴 쪽을 THUMBNAIL_MAX 로 줄임
				double scale = Math.min(1.0, (double) THUMBNAIL_MAX / Math.max(image.getWidth(), image.getHeight()));
				Thumbnails.of(saveFile).scale(scale).toFile(new File(dir, fileName(dto, true)));
			} catch (IOException e) {
				throw new IllegalStateException("파일 저장 실패: " + original, e);
			}
			result.add(dto);
		}
		return result;
	}

	/** 원본 + 썸네일 삭제 (하나가 없어도 나머지는 지운다) */
	public void delete(AuctFileUploadDTO dto) {
		File dir = new File(rootDir, dto.getUpload_path());
		for (boolean thumbnail : new boolean[] { false, true }) {
			File file = new File(dir, fileName(dto, thumbnail));
			try {
				Files.deleteIfExists(file.toPath());
			} catch (IOException e) {
				logger.warn("파일 삭제 실패: {}", file, e);
			}
		}
	}

	/** 브라우저에서 /web/upload/ 뒤에 붙일 경로 */
	public static String urlPath(AuctFileUploadDTO dto, boolean thumbnail) {
		return dto.getUpload_path().replace('\\', '/') + "/" + fileName(dto, thumbnail);
	}

	private static String fileName(AuctFileUploadDTO dto, boolean thumbnail) {
		return (thumbnail ? "s_" : "") + dto.getFile_name() + "_" + dto.getFile_dname() + dto.getFile_ext();
	}

	private static String extensionOf(String filename) {
		if (filename == null) {
			return "";
		}
		int dot = filename.lastIndexOf('.');
		return dot < 0 ? "" : filename.substring(dot).toLowerCase(Locale.ROOT);
	}

	private static String sanitize(String name) {
		String cleaned = name.replaceAll("[^0-9A-Za-z가-힣_-]", "_");
		if (cleaned.isEmpty()) {
			cleaned = "image";
		}
		return cleaned.length() > 50 ? cleaned.substring(0, 50) : cleaned;
	}
}
