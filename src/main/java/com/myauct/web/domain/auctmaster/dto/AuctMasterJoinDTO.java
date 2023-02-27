package com.myauct.web.domain.auctmaster.dto;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctMasterJoinDTO {
    private int jnum, unum, anum, amount, volume;
    private char join_gb, cancel_chk;
    private Date join_created;
	
}
