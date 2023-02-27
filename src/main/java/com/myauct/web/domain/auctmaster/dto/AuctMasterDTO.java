package com.myauct.web.domain.auctmaster.dto;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AuctMasterDTO {
    private int anum, unum, cnum, limit_amt, join_amt, join_cnt, curr_amt, total_cnt, start_amt, RN;
    private String sales_addr, prod_name, auct_start, auct_end, prod_img, contents, prod_title;
    private char prod_type, as_type, limit_type, trans_type, con_html, end_chk, delete_chk;
    private Date reg_date;
    
}
