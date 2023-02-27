package com.myauct.web.domain.auctmaster.dto;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctFileUploadDTO {
	private int anum;
	private String upload_path, file_name, file_dname, file_ext;
}
