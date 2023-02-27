package com.myauct.web.domain.auctboard.dto;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctBoardMemoDTO {
    private int mnum, qnum, unum;
    private String memo, wdate;
}
