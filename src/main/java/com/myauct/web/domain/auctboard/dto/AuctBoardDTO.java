package com.myauct.web.domain.auctboard.dto;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctBoardDTO {
    private int qnum, unum, anum, re_cnt, views;
    private String subject, contents, wdate;
     

}
