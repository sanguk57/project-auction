package com.myauct.web.global;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 서버가 시작될 때 어떤 설정 파일을 읽었는지 로그로 알려준다.
 * (설정 파일 위치는 root-context.xml / servlet-context.xml 의 property-placeholder 와 같은 규칙)
 *
 * 바깥 설정 파일이 없으면 서버는 뜨지만 DB 비밀번호가 비어 있어 첫 화면에서 오류가 나므로,
 * 원인을 바로 알 수 있도록 경고를 남긴다.
 */
@Component
public class ConfigReporter implements InitializingBean {

	private static final Logger logger = LoggerFactory.getLogger(ConfigReporter.class);
	static final String DEFAULT_PATH = "C:/myauct/app.properties";

	@Value("${db.password:}")
	private String dbPassword;

	@Value("${upload.path:}")
	private String uploadPath;

	@Value("${juso.confmKey:}")
	private String jusoKey;

	/** -Dmyauct.config > MYAUCT_CONFIG 환경변수 > C:/myauct/app.properties */
	static String configPath() {
		String path = System.getProperty("myauct.config");
		if (path == null || path.isBlank()) {
			path = System.getenv("MYAUCT_CONFIG");
		}
		return (path == null || path.isBlank()) ? DEFAULT_PATH : path;
	}

	@Override
	public void afterPropertiesSet() {
		File file = new File(configPath());
		if (file.isFile()) {
			logger.info("설정 파일: {}", file.getAbsolutePath());
		} else {
			logger.warn("설정 파일이 없습니다: {} → config/app.properties.example 을 이 위치로 복사해서 값을 채워주세요.",
					file.getAbsolutePath());
		}
		if (dbPassword.isEmpty()) {
			logger.warn("db.password 가 비어 있습니다. 설정 파일에 DB 비밀번호를 적어주세요.");
		}
		logger.info("업로드 폴더: {}{}", uploadPath, new File(uploadPath).isDirectory() ? "" : " (없음 → 첫 업로드 때 만들어짐)");
		logger.info("주소 검색 API 키: {}", jusoKey.isEmpty() ? "없음 (직접 입력 안내 표시)" : "설정됨");
	}
}
