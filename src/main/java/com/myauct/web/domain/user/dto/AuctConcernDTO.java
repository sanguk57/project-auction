package com.myauct.web.domain.user.dto;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctConcernDTO {
    private int inum, unum, anum;
    private Date wdate;
}
