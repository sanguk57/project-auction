package com.myauct.web.domain.auctmaster;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;
import com.myauct.web.domain.auctboard.service.AuctBoardMemoService;
import com.myauct.web.domain.auctboard.service.AuctBoardService;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctconcern.service.AuctConcernService;
import com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctFileUploadService;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

import lombok.RequiredArgsConstructor;
import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping("/aucts")
@RequiredArgsConstructor
public class AuctMasterController {

	private static final Logger logger = LoggerFactory.getLogger(AuctMasterController.class);

	private final UserService userService;
	private final AuctCategoryService auctCategoryService;
	private final AuctMasterService auctMasterService;
	private final AuctFileUploadService auctFileUploadService;
	private final AuctConcernService auctConcernService;
	private final AuctBoardService auctBoardService;
	private final AuctBoardMemoService auctBoardMemoService;
	
	@RequestMapping("/loginUser")
	public String loginUser(String user_id, HttpSession session) {
		
		if (session.isNew()) {
			UserDTO dto = userService.getUser(user_id);
			session.setAttribute("user", dto);
		} else {
			session.removeAttribute("user");
			UserDTO dto = userService.getUser(user_id);
			session.setAttribute("user", dto);
		}
		
		return "redirect:/aucts/index";
	}
	@RequestMapping("/index")
	public void index(
			 HttpSession session, Model model, PagingDTO pagingDTO,
			 @RequestParam(value="value", required=false, defaultValue="") String value,
			@RequestParam(value="key", required=false) String key,
			@RequestParam(defaultValue = "1") int nowPage,
			@RequestParam(defaultValue = "4") int cntPerPage) {
		
		Map<String, Integer> cntMap = new HashMap<String, Integer>();
		// 세션에 로그인 회원 정보 보관
		
		int unum = 0;
		int userProductCnt = 0;
		int concernCnt = 0;
		int boardCnt = 0;
		int total  = 0;
		
		if(session.getAttribute("user") != null) {			
			UserDTO dto = (UserDTO) session.getAttribute("user");
			unum = dto.getUnum();
			
			userProductCnt = auctMasterService.getUserProductCnt(unum);
			cntMap.put("userProductCnt", userProductCnt);
			
			concernCnt = auctConcernService.concernCnt(unum);
			cntMap.put("concernCnt", concernCnt);
			
			total = auctMasterService.getProductCnt(value);
			cntMap.put("productCnt", total);
			
			boardCnt = auctBoardService.userBoardCnt(unum);
			cntMap.put("userBoardCnt", boardCnt);

		    if(key != null) {
		        if(key.equals("A")) {
		            pagingDTO = new PagingDTO(userProductCnt, nowPage, cntPerPage, value, key, unum);
		            model.addAttribute("paging", pagingDTO);
		        } else if(key.equals("B")) {
		            pagingDTO = new PagingDTO(concernCnt, nowPage, cntPerPage, value, key, unum);
		            model.addAttribute("paging", pagingDTO);
		        } else {
		            pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
		            model.addAttribute("paging", pagingDTO);
		        }
		    } else {
		        pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
		        model.addAttribute("paging", pagingDTO);
		    }
		} else {
		    total = auctMasterService.getProductCnt(value);
		    cntMap.put("productCnt", total);
		    
		    pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
		    model.addAttribute("paging", pagingDTO);
		}
		
		
		List<AuctMasterDTO> productList = auctMasterService.getProductList(pagingDTO);
		model.addAttribute("cntMap", cntMap);
		model.addAttribute("productList", productList);
	}

	@GetMapping("/about")
	public void about( HttpSession session, Model model, PagingDTO pagingDTO,
			@RequestParam(value="value", required=false, defaultValue="") String value,
			@RequestParam(value="key", required=false) String key,
			@RequestParam(defaultValue = "1") int nowPage,
			@RequestParam(defaultValue = "12") int cntPerPage) {
		
		Map<String, Integer> cntMap = new HashMap<String, Integer>();
		// 세션에 로그인 회원 정보 보관
		
		int unum = 0;
		int userProductCnt = 0;
		int concernCnt = 0;
		int boardCnt = 0;
		int total  = 0;
		
		if(session.getAttribute("user") != null) {			
			UserDTO dto = (UserDTO) session.getAttribute("user");
			unum = dto.getUnum();
			
			userProductCnt = auctMasterService.getUserProductCnt(unum);
			cntMap.put("userProductCnt", userProductCnt);
			
			concernCnt = auctConcernService.concernCnt(unum);
			cntMap.put("concernCnt", concernCnt);
			
			total = auctMasterService.getProductCnt(value);
			cntMap.put("productCnt", total);
			
			boardCnt = auctBoardService.userBoardCnt(unum);
			cntMap.put("userBoardCnt", boardCnt);

			  if(key != null) {
			        if(key.equals("A")) {
			            pagingDTO = new PagingDTO(userProductCnt, nowPage, cntPerPage, value, key, unum);
			            model.addAttribute("paging", pagingDTO);
			        } else if(key.equals("B")) {
			            pagingDTO = new PagingDTO(concernCnt, nowPage, cntPerPage, value, key, unum);
			            model.addAttribute("paging", pagingDTO);
			        } else {
			            pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
			            model.addAttribute("paging", pagingDTO);
			        }
			    } else {
			        pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
			        model.addAttribute("paging", pagingDTO);
			    }
			} else {
			    total = auctMasterService.getProductCnt(value);
			    cntMap.put("productCnt", total);
			    
			    pagingDTO = new PagingDTO(total, nowPage, cntPerPage, value, key, unum);
			    model.addAttribute("paging", pagingDTO);
			}
		
		
		List<AuctMasterDTO> productList = auctMasterService.getProductList(pagingDTO);
		model.addAttribute("cntMap", cntMap);
		model.addAttribute("productList", productList);
	}

	@GetMapping("/contact")
	public void contact() {
	}

	@RequestMapping("/productEnrollment")
	public void get_a_quote() {
	}

	@RequestMapping("/jusoPopup")
	public void jusoPopup() {
	}

	@GetMapping("/pricing")
	public void pricing() {
	}
	
	@GetMapping("/sample-inner-page")
	public void sample_inner_page() {
	}

	@RequestMapping("/service-details")
	public void service_details(Model model) {
	}

	@GetMapping("/services")
	public void services() {
	}

	@GetMapping("/modifyProduct")
	public void modifyProduct(int anum, Model model) {
		AuctMasterDTO dto = auctMasterService.getProduct(anum);
		
		 String category =  auctCategoryService.getCategory(dto.getCnum());
		 model.addAttribute("category", category);
		model.addAttribute("aDTO",dto);
	}
	
	@PostMapping("/productModify")
	public String productModify(AuctMasterDTO auctMasterDTO, MultipartFile[] uploadFile, AuctCategoryDTO categoryDTO) {
		if(categoryDTO.getCnum() == 0) {
			auctCategoryService.registerCategory(categoryDTO);
			auctMasterDTO.setCnum(categoryDTO.getCnum());
		}
		auctMasterService.moidfyProduct(auctMasterDTO);
		return "redirect:/aucts/productView";
	}
	
	@GetMapping("/deleteProduct")
	public String deleteProduct (int anum) {
		 auctMasterService.deleteProduct(anum);
		return "redirect:/aucts/index";
	}
	
	
	@RequestMapping("/auctionItem")
	public String auctioniItem(AuctMasterDTO auctMasterDTO, AuctCategoryDTO categoryDTO, MultipartFile[] uploadFile) {

		System.out.println(auctMasterDTO);
		System.out.println(categoryDTO);
		if(categoryDTO.getCnum() == 0) {
			auctCategoryService.registerCategory(categoryDTO);
			auctMasterDTO.setCnum(categoryDTO.getCnum());
		}
		auctMasterService.createProduct(auctMasterDTO);
		
		int anum = auctMasterDTO.getAnum();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		String datePath = str.replace("-", File.separator);

		String uploadFolder = File.separator + "Users" + File.separator + "Kungas_57" + File.separator + "Desktop"
				+ File.separator + "study_java" + File.separator + "Spring_STS" + File.separator + "myAuct"
				+ File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator
				+ "resources" + File.separator + "upload";

		File uploadPath = new File(uploadFolder, datePath);

		// 폴더가 없으면 생성
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}

		logger.info(uploadFile[0].getName() + ", " + uploadFile[0].getSize());
		auctMasterDTO.setProd_img(uploadFile[0].getName());
		
		for (MultipartFile multipartFile : uploadFile) {
			
			String uploadFileName = multipartFile.getOriginalFilename();
			logger.info(uploadFileName);
			
			AuctFileUploadDTO auctFileUploadDTO = new AuctFileUploadDTO();
			
			// 확장자 추출 (.jpg, .png)
			String ext = uploadFileName.substring(uploadFileName.lastIndexOf("."));
			
			// 파일명 추출
			String filerename = uploadFileName.substring(0, uploadFileName.lastIndexOf("."));
			auctFileUploadDTO.setFile_name(filerename);

			String now = new SimpleDateFormat("yyyyMMdd_HmssS").format(new Date());
			auctFileUploadDTO.setFile_dname(now);
			
			auctFileUploadDTO.setUpload_path(datePath);
			auctFileUploadDTO.setAnum(anum);
			auctFileUploadDTO.setFile_ext(ext);
			
			auctFileUploadService.fileUpload(auctFileUploadDTO);
			
			// 새로운 파일 이름('업로드일시.확장자')
			String newFileName = filerename + "_" + now + ext;

			/* 파일 위치, 파일 이름을 합친 File 객체 */
			File saveFile = new File(uploadPath, newFileName);

			/* 파일 저장 */
			try {
				multipartFile.transferTo(saveFile);
				
//				/*썸네일 이미지*/
//				File thumbnailFile = new File(uploadPath, "s_" + newFileName);
//				
//				BufferedImage bo_image = ImageIO.read(saveFile);
//				
//				/* 비율 */
//				double ratio = 3;
//				
//				/*넓이 높이*/
//				int width = (int) (bo_image.getWidth() / ratio);
//				int height = (int) (bo_image.getHeight() / ratio);
//				
//				BufferedImage bt_image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
//
//				Graphics2D graphic = bt_image.createGraphics();
//
//				graphic.drawImage(bo_image, 0, 0, width, height, null);
//
//				ImageIO.write(bt_image, "png", thumbnailFile);
				
				// thumbnailator 라이브러리 사용 
				
				File thumbnailFile = new File(uploadPath, "s_" + newFileName);

				BufferedImage bo_image = ImageIO.read(saveFile);

				// 비율
				double ratio = 3;
				// 넓이 높이
				int width = (int) (bo_image.getWidth() / ratio);
				int height = (int) (bo_image.getHeight() / ratio);

				Thumbnails.of(saveFile).size(width, height).toFile(thumbnailFile);

			} catch (Exception e) {
				e.printStackTrace();
			}
			
			
		} // for end

		return "redirect:/aucts/index";
	}
	
	@GetMapping("/productView")
	public String productView(int anum, Model model) {
		List<String> uploadFileList = new ArrayList<String>();
		List<String> nameList = new ArrayList<String>();
		List<Integer> memoCntList = new ArrayList<Integer>();
		
		AuctMasterDTO auctMasterDTO = auctMasterService.getProduct(anum);
		
		List<AuctBoardDTO> boardList = auctBoardService.boardList();
		
		for(AuctBoardDTO dto : boardList) {
			nameList.add(userService.getName(dto.getUnum()));
//			memoCntList의 순서대로 qnum을 받아와 거기에 달린 답글을 List에 순서대로 저
			memoCntList.add(auctBoardMemoService.MemoCnt(dto.getQnum()));
		}
		
		
		String category = auctCategoryService.getCategory(auctMasterDTO.getCnum());
		
		List<AuctFileUploadDTO> fileList = auctFileUploadService.fileList(anum);
		
		for(AuctFileUploadDTO dto : fileList) {
			String sImgFile = dto.getUpload_path()+"/"+dto.getFile_name()+"_"+dto.getFile_dname()+dto.getFile_ext();
			uploadFileList.add(sImgFile);
		}
		model.addAttribute("memoCntList", memoCntList);
		model.addAttribute("boardList", boardList);
		model.addAttribute("nameList", nameList);
		model.addAttribute("auctMasterDTO", auctMasterDTO);
		model.addAttribute("category", category);
		model.addAttribute("uploadFileList", uploadFileList);
		
		return "aucts/service-details";
	}
}
