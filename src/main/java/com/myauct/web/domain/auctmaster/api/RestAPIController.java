package com.myauct.web.domain.auctmaster.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;
import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;
import com.myauct.web.domain.auctboard.service.AuctBoardMemoService;
import com.myauct.web.domain.auctboard.service.AuctBoardService;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctconcern.dto.AuctConcernDTO;
import com.myauct.web.domain.auctconcern.service.AuctConcernService;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;
import com.myauct.web.domain.auctmaster.service.AuctFileUploadService;
import com.myauct.web.domain.auctmaster.service.AuctMasterJoinService;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/product-api")
@RestController
@RequiredArgsConstructor
public class RestAPIController {

	private final AuctMasterJoinService auctMasterJoinService;
	private final AuctMasterService auctMasterService;
	private final AuctCategoryService auctCategoryService;
	private final AuctFileUploadService auctFileUploadService;
	private final AuctConcernService auctConcernService;
	private final AuctBoardService auctBoardService;
	private final AuctBoardMemoService auctBoardMemoService;
	
	private static final Logger logger = LoggerFactory.getLogger(RestAPIController.class);
	
	@PostMapping("/uploadAjaxAction")
	public ResponseEntity<Map<String, List<String>>> uploadAjaxAction(@RequestBody HashMap<String, Integer[]> map) {
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "application/json;charset=UTF-8");

		Map<String, List<String>> fileMap = new HashMap<>();
		List<String> anumList = new ArrayList<String>();

		for (int anum : map.get("anum")) {
			if (!auctFileUploadService.fileList(anum).isEmpty()) {
				List<AuctFileUploadDTO> list = auctFileUploadService.fileList(anum);
				for (AuctFileUploadDTO dto : list) {

					String sImgFile = dto.getUpload_path() + "/s_" + dto.getFile_name() + "_" + dto.getFile_dname()
							+ dto.getFile_ext();
					anumList.add(sImgFile);
					fileMap.put("" + anum, anumList);
				}
			}
		}
		return new ResponseEntity<Map<String, List<String>>>(fileMap, resHeaders, HttpStatus.OK);
	}

	@PutMapping("/product_auction")
	public void productAmt(@RequestBody HashMap<String, Integer> map) {
		
		
		AuctMasterJoinDTO auctMasterJoinDTO = new AuctMasterJoinDTO();
		int start_amt = map.get("start_amt"), anum = map.get("anum"),
				unum = map.get("unum"), volume = map.get("volume"), amount = map.get("amount");
		
		
		auctMasterJoinDTO.setAmount(amount);
		auctMasterJoinDTO.setUnum(unum);
		auctMasterJoinDTO.setVolume(volume);
		auctMasterJoinDTO.setAnum(anum);
		
		auctMasterJoinService.auctionApplicant(auctMasterJoinDTO);

		int join_cnt = auctMasterJoinDTO.getJnum();
		auctMasterService.modifyProductAmt(start_amt, anum, join_cnt);
	}

	@PostMapping("/product_category")
	public ResponseEntity<Map<Integer, String>> productCate() {
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "application/json;charset=UTF-8");
		Map<Integer, String> categoryMap = new HashMap<Integer, String>(); 

		List<AuctCategoryDTO> categoryAllList = auctCategoryService.getCategoryList();
		for (AuctCategoryDTO dto : categoryAllList) {
			categoryMap.put(dto.getCnum(), dto.getCategory()); 
		}

		return new ResponseEntity<Map<Integer, String>>(categoryMap, resHeaders, HttpStatus.OK);
	}

	@PostMapping("/product_concern")
	public void product_concern(@RequestBody HashMap<String, Integer> map) {
		int anum = map.get("anum"), unum = map.get("unum");
		logger.info("--------------------"+anum);
		AuctConcernDTO auctConcernDTO = new AuctConcernDTO();
		auctConcernDTO.setAnum(anum);
		auctConcernDTO.setUnum(unum);
		
		auctConcernService.createConcnern(auctConcernDTO);
	}
	
	@DeleteMapping("/product_unconcern")
	public void product_unconcern(@RequestBody HashMap<String, Integer> map) {
	int anum = map.get("anum"), unum = map.get("unum");
		
		auctConcernService.deleteConcnern(anum, unum);
	}
	
	@PostMapping("/concern_list")
	public ResponseEntity<List<Integer>> concern_list(@RequestBody HashMap<String, Integer> map){
		int unum = map.get("unum");
		List<Integer> anumList = new ArrayList<Integer>();
		
		List<AuctConcernDTO> concernList = auctConcernService.concernList(unum);
		for(AuctConcernDTO dto : concernList){
			anumList.add(dto.getAnum());
		}
		return new ResponseEntity<List<Integer>> (anumList, HttpStatus.OK);
	}
	
	@PostMapping("/create_board")
	public ResponseEntity<String> create_board(@RequestBody HashMap<String, Object> map){
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "application/json;charset=UTF-8");
		AuctBoardDTO auctBoardDTO = new AuctBoardDTO();
		auctBoardDTO.setAnum((int)map.get("anum"));
		auctBoardDTO.setUnum((int)map.get("unum"));
		auctBoardDTO.setSubject((String)map.get("subject"));
		auctBoardDTO.setContents((String)map.get("contents"));
		
		auctBoardService.createBoard(auctBoardDTO);
		return new ResponseEntity<String> ("댓글쓰기 success", resHeaders, HttpStatus.OK);
	}
	
	@PostMapping("/create_memo")
	public ResponseEntity<String> create_memo(@RequestBody HashMap<String, Object> map){
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "application/json;charset=UTF-8");
		
		AuctBoardMemoDTO auctBoardMemoDTO = new AuctBoardMemoDTO();
		auctBoardMemoDTO.setQnum((int)map.get("qnum"));
		auctBoardMemoDTO.setUnum((int)map.get("unum"));
		auctBoardMemoDTO.setMemo((String)map.get("memo"));
		
		auctBoardMemoService.CreateMemo(auctBoardMemoDTO);
		return new ResponseEntity<String> ("답글쓰기 success", resHeaders, HttpStatus.OK);
	}
	@PostMapping("/memoList")
	public ResponseEntity<List<AuctBoardMemoDTO>> memoList(@RequestBody HashMap<String, Integer> map){
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "application/json;charset=UTF-8");
		
		List<AuctBoardMemoDTO> memoList = auctBoardMemoService.getMemoList(map.get("qnum"));
		
		return new ResponseEntity<List<AuctBoardMemoDTO>> (memoList, resHeaders, HttpStatus.OK);
	}
}
