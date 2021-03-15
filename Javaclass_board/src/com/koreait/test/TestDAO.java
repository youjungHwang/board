package com.koreait.test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.koreait.db.Dbconn;

public class TestDAO {

	Connection conn =null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql="";
	
	
	// write() - write_ok.jsp
	public int write(TestDTO test) {
		try {
			// idx는 Mysql에서 자동생성되므로 insert문에서 안씀(select할 때 사용)
			sql = "insert into tb_itest (b_name, b_userid, b_userpw, b_title, b_content, b_filename) values (?, ?, ?, ?, ?, ?)";
			
			
			conn = Dbconn.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, test.getName());
			pstmt.setString(2, test.getUserid());
			pstmt.setString(3, test.getUserpw());
			pstmt.setString(4, test.getTitle());
			pstmt.setString(5, test.getContent());
			pstmt.setString(6, test.getFilename());
			if(pstmt.executeUpdate() !=0) {
				return 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	
	//  page() - list.jsp 
	public int[] page(String pageNum) { // return :  totalCount, pagePerCount, start, pageNums 
		
		// 선언과 동시에 배열크기 할당
		int[] arr = new int[4];
		
		// [페이징]
        int totalCount = 0; 		// 전체 글 개수
        int pagePerCount = 3; 		// 페이지당 글 개수(10개씩 보여달라)
        int start = 0; 				// (페이지마다)시작 글 번호, 계속 바꿔줘야 한다
        int pageNums = 0; 			// pagination
       
        
       
        start = (Integer.parseInt(pageNum)-1) * pagePerCount; 
        
      
        try {
        	
        	sql = "select count(b_idx) as total from tb_itest"; // 워크벤치 후 sql작성
        	conn = Dbconn.getConnection();
        	pstmt = conn.prepareStatement(sql);
        	rs = pstmt.executeQuery();
  	  		if(rs.next()){
  	  		totalCount = rs.getInt("total"); 					// 필드명을 숫자로 가져와서 넣어줌
  	  		}
  	  	
  	  		// [페이징 숫자만들기]
  	  		
  	  		if(totalCount % pagePerCount ==0){
  	  			pageNums =  (totalCount / pagePerCount); 		// (정수 / 정수)
  	  		}else{
  	  			pageNums =  (totalCount / pagePerCount) +1; 	// 소수점은 1페이지로 처리 
  	  		}
  
  	  }catch(Exception e){
  		  e.printStackTrace();
  	  }
        arr[0] = totalCount;
        arr[1] = pagePerCount;
        arr[2] = start;
        arr[3] = pageNums;
        
        return arr;
	       
}
	// 게시글 보여주기
	public List<TestDTO> list(int start, int pagePerCount) {
		sql = "select * from tb_itest order by b_idx desc limit ?, ?";
		List<TestDTO> pagelist = new ArrayList<>();
		
		try {
			conn = Dbconn.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	    	pstmt.setInt(1, start);
	    	pstmt.setInt(2, pagePerCount);
	    	rs = pstmt.executeQuery();
	    	
	    	while(rs.next()) {
	    		TestDTO testDTO = new TestDTO();
	    		testDTO.setIdx(rs.getInt("b_idx"));
	    		testDTO.setUserid(rs.getString("b_userid"));
	    		testDTO.setName(rs.getString("b_name"));
	    		testDTO.setTitle(rs.getString("b_title"));
	    		testDTO.setHit(rs.getInt("b_hit"));
	    		testDTO.setFilename(rs.getString("b_filename"));
	    		pagelist.add(testDTO);
	    	}
		}catch(Exception e) {
			e.printStackTrace();
		}
    	return pagelist;
	}
	
	// view.jsp - view단
	public TestDTO view(int idx) {
		sql = "select * from tb_itest where b_idx=?";
		TestDTO testDTO = new TestDTO();
	
	 try{
         
		   conn = Dbconn.getConnection();
           pstmt= conn.prepareStatement(sql);
           pstmt.setInt(1, idx);
           rs = pstmt.executeQuery(); 
           
           if(rs.next()){ 
       		testDTO.setUserid(rs.getString("b_userid"));
       		testDTO.setUserpw(rs.getString("b_userpw")); //!
       		testDTO.setName(rs.getString("b_name"));
       		testDTO.setTitle(rs.getString("b_title"));
       		testDTO.setContent(rs.getString("b_content"));
       		testDTO.setHit(rs.getInt("b_hit"));
       		testDTO.setFilename(rs.getString("b_filename"));
           }

      }catch(Exception e){
         e.printStackTrace();
      }
	 	return testDTO;

		
	}
	
	// ip -view.jsp
	public void ipCheck(String ip, String idx) {
		sql = "select ip_idx from tb_iptable where ip_box=? and ip_itestidx=?";
		
		try {
			   conn = Dbconn.getConnection();
	           pstmt= conn.prepareStatement(sql);
	           pstmt.setString(1, ip);
	           pstmt.setString(2, idx);
	           rs = pstmt.executeQuery(); 
	           
	           if(rs.next()){ 
	        	   // 이미 들어왔던 ip
	          		return;
	              }
	           
	     sql = "insert into tb_iptable(ip_box, ip_itestidx) values(?, ?)";
	     	pstmt= conn.prepareStatement(sql);
	     	pstmt.setString(1, ip);
	     	pstmt.setString(2, idx);
	     	pstmt.executeUpdate();
	     
	     // 조회수 +1
	     sql = "update tb_itest set b_hit = b_hit+1 where b_idx=?";
	     	pstmt= conn.prepareStatement(sql);
	     	pstmt.setInt(1, Integer.parseInt(idx));
	     	pstmt.executeUpdate();
	           
		}catch(Exception e){
	         e.printStackTrace();
	      }
	}
	
	// 댓글 - view.jsp
	public int addreply(ReplyDTO reply) {
			try {
				
				sql = "insert into tb_reitest (re_name, re_content, re_itestIdx) values (?, ?, ?)";
				
				
				conn = Dbconn.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, reply.getRe_name());
				pstmt.setString(2, reply.getRe_content());
				pstmt.setInt(3, reply.getRe_itestidx());
				
				if(pstmt.executeUpdate() !=0) {
					// 성공
					return 1;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
			return 0;
		}
	
	// 댓글 가져오기
		public List<ReplyDTO> replylist(String b_idx) {
			sql = "select * from tb_reitest where re_itestIdx=? order by re_idx desc";
			List<ReplyDTO> replylist = new ArrayList<>();
			
			try {
				conn = Dbconn.getConnection();
		    	pstmt = conn.prepareStatement(sql);
		    	pstmt.setInt(1,Integer.parseInt(b_idx));
		    	rs = pstmt.executeQuery();
		    	
		    	while(rs.next()) {
		    		ReplyDTO reply = new ReplyDTO();
		    		reply.setRe_name(rs.getString("re_name"));
		    		reply.setRe_content(rs.getString("re_content"));
		    		replylist.add(reply);
		    	}
			}catch(Exception e) {
				e.printStackTrace();
			}
	    	return replylist;
		}
		
	
	
	
}
