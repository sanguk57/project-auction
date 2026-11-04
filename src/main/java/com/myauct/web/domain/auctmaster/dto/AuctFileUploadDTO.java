package com.myauct.web.domain.auctmaster.dto;

import lombok.Data;

@Data
public class AuctFileUploadDTO {
	private int fnum, anum;
	/** 작을수록 앞. 첫 번째 사진이 대표(목록 썸네일) 사진 */
	private int sort_no;
	private String upload_path, file_name, file_dname, file_ext;

	/** 화면용: /web/upload/ 뒤에 붙일 원본 경로 (윈도우 경로 구분자도 / 로) */
	public String getUrl() {
		return upload_path.replace('\\', '/') + "/" + file_name + "_" + file_dname + file_ext;
	}

	/** 화면용: 썸네일 경로 */
	public String getThumbUrl() {
		return upload_path.replace('\\', '/') + "/s_" + file_name + "_" + file_dname + file_ext;
	}
}
