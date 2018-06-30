package bean;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import DO.*;

import org.json.*;

import com.google.gson.JsonObject;

public class Db_connection {

	Connection conn = null;
	PreparedStatement pstmt = null;

	// Oracle
	String jdbc_driver = "oracle.jdbc.driver.OracleDriver";
	String jdbc_url = "jdbc:oracle:thin:@localhost:1521:xc";

	// postgre
	// String jdbc_driver = "org.postgresql.Driver";
	// String jdbc_url = "jdbc:postgresql://localhost:5432/webHtp";

	void connect() {
		try {
			Class.forName(jdbc_driver);
			conn = DriverManager.getConnection(jdbc_url, "system", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	void disconnect() {
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public login_DO selectDB(String id, String pass) {
		connect();
		login_DO ob = new login_DO();
		
		String sql = "select nurse_login.LOGINID,nurse_login.LOGINPW from nurse_login where LOGINID=? and LOGINPW=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pass);

			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			
			ob.setId(rs.getString("LOGINID"));
			ob.setPass(rs.getString("LOGINPW"));
			
			rs.close();

		} catch (SQLException e) {
			ob = null;
			e.printStackTrace();
		}

		disconnect();

		return ob;
	}
	
	public String rankDB(String id, String pass) {
		connect();
		check_DO ob = new check_DO();
		
		String sql = "select nurse_login.LOGINID,nurse_login.LOGINPW,nurse_login.RANK from nurse_login where LOGINID=? and LOGINPW=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pass);

			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			
			ob.setId(rs.getString("LOGINID"));
			ob.setPass(rs.getString("LOGINPW"));
			ob.setRank(rs.getString("RANK"));
			
			rs.close();

		} catch (SQLException e) {
			ob = null;
			e.printStackTrace();
		}

		disconnect();

		return ob.getRank();
	}
	
	
	public boolean updateDB(Patientinfo_DO up) {
		connect();
		
		String sql ="update patientinfo set name=?, age=?, phone=?, protector_name=?, protector_phone=? where id=?";		
		 
		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, up.getName());
			pstmt.setInt(2, up.getAge());
			pstmt.setString(3, up.getPhone());
			pstmt.setString(4, up.getProtector_name());
			pstmt.setString(5, up.getProtector_phone());
			pstmt.setInt(6, up.getId());
			
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		finally {
			disconnect();
		}
		return true;
	}
	
	public boolean deupdateDB(PatientDetail_DO dup) {
	connect();
	
	String sql ="update medical_record set patient_room=?, bpm=?, body_temp=?, respiration=?, blood_pressure=?, the_others=? where id=?";		
	 
	try {
		pstmt = conn.prepareStatement(sql);
	
		pstmt.setString(1, dup.getPatient_room());
		pstmt.setInt(2, dup.getBpm());
		pstmt.setDouble(3, dup.getBody_temp());
		pstmt.setInt(4, dup.getRespiration());
		pstmt.setInt(5, dup.getBlood_pressure());
		pstmt.setString(6, dup.getThe_others());
		pstmt.setInt(7, dup.getId());
		
		pstmt.executeUpdate();
	} catch (SQLException e) {
		e.printStackTrace();
		return false;
	}
	finally {
		disconnect();
	}
	return true;
}
	
	// 특정 주소록 게시글 삭제 메서드
	public boolean deleteDB(int gb_id) {
		connect();
		
		PreparedStatement pstmt1 = null;
		
		String sql ="delete from patientinfo where id=?";
		String sql1 ="delete from medical_record where id=?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt1 = conn.prepareStatement(sql1);
			
			pstmt.setInt(1,gb_id);
			pstmt.executeUpdate();
			
			pstmt1.setInt(1,gb_id);
			pstmt1.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		finally {
			disconnect();
		}
		return true;
	}
	
	
	// 신규 주소록 메시지 추가 메서드
	public boolean insertDB(nurse_DO nurse) {
		connect();
		// sql 문자열 , gb_id 는 자동 등록 되므로 입력하지 않는다.

		String sql = "insert into nurse_login values(?,?,?,?,?,?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nurse.getLoginid());
			pstmt.setString(2, nurse.getPassword());
			pstmt.setString(3, nurse.getName());
			pstmt.setInt(4, nurse.getTeam());
			pstmt.setString(5, nurse.getPhone());
			pstmt.setString(6, nurse.getRank());
			pstmt.executeUpdate();
			System.out.println("성공");
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			disconnect();
		}
		return true;
	}
	
	public boolean patient_insertDB(Patientinfo_DO pd) {
		connect();
		// sql 문자열 , gb_id 는 자동 등록 되므로 입력하지 않는다.

		String sql = "insert into  patientinfo(id, name, age, phone,protector_name, protector_phone)  values(?,?,?,?,?,?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pd.getId());
			pstmt.setString(2, pd.getName());
			pstmt.setInt(3, pd.getAge());
			pstmt.setString(4, pd.getPhone());
			pstmt.setString(5, pd.getProtector_name());
			pstmt.setString(6, pd.getProtector_phone());
			pstmt.executeUpdate();
			System.out.println("성공");
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			disconnect();
		}
		return true;
	}
	
	public boolean patientDetail_insertDB(PatientDetail_DO po) {
		connect();
		// sql 문자열 , gb_id 는 자동 등록 되므로 입력하지 않는다.

		String sql = "insert into medical_record (id,patient_room,bpm,body_temp,respiration,blood_pressure,the_others) values(?,?,?,?,?,?,?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, po.getId());
			pstmt.setString(2, po.getPatient_room());
			pstmt.setInt(3, po.getBpm());
			pstmt.setDouble(4, po.getBody_temp());
			pstmt.setInt(5, po.getRespiration());
			pstmt.setInt(6, po.getBlood_pressure());
			pstmt.setString(7, po.getThe_others());
			
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			disconnect();
		}
		return true;
	}


	// 특정 주소록 게시글 가져오는 메서드
	public Patient_DO getDB(int gb_id) {
		connect();

		String sql = "select patientinfo.NAME,patientinfo.AGE,medical_record.* from patientinfo, medical_record where patientinfo.id = medical_record.id and patientinfo.id=? order by medical_record.id asc";
		Patient_DO pa = new Patient_DO();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, gb_id);
			ResultSet rs = pstmt.executeQuery();

			// 데이터가 하나만 있으므로 rs.next()를 한번만 실행 한다.
			while (rs.next()) {
			
			pa.setName(rs.getString("NAME"));
			pa.setId(rs.getInt("ID"));
			pa.setAge(rs.getString("AGE"));
			pa.setPatient_room(rs.getString("PATIENT_ROOM"));
			pa.setBpm(rs.getString("BPM"));
			pa.setBody_temp(rs.getString("BODY_TEMP"));
			pa.setRespiration(rs.getString("RESPIRATION"));		
			pa.setBlood_pressure(rs.getString("BLOOD_PRESSURE"));
			pa.setThe_others(rs.getString("THE_OTHERS"));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return pa;
	}

	// 전체 주소록 목록을 가져오는 메서드
	
	
	public ArrayList<nurse_DO> getDBList() {
		connect();
		ArrayList<nurse_DO> datas = new ArrayList<nurse_DO>();

		String sql = " select * from nurse_login order by LOGINID asc ";
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				nurse_DO nurse = new nurse_DO();

				nurse.setLoginid(rs.getString("LOGINID"));
				nurse.setName(rs.getString("NAME"));
				nurse.setPassword(rs.getString("LOGINPW"));
				nurse.setPhone(rs.getString("PHONE"));
				nurse.setTeam(rs.getInt("TEAM"));	
				nurse.setRank(rs.getString("RANK"));		
				datas.add(nurse);

			}
			rs.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return datas;
	}
	
	

	public ArrayList<Patient_DO> getDBList1() {
		connect();
		ArrayList<Patient_DO> datas1 = new ArrayList<Patient_DO>();

		String sql = "select patientinfo.NAME,patientinfo.AGE,medical_record.* from patientinfo, medical_record where patientinfo.id = medical_record.id order by medical_record.id asc";

		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				Patient_DO pa = new Patient_DO();

				pa.setId(rs.getInt("ID"));
				pa.setBlood_pressure(rs.getString("BLOOD_PRESSURE"));
				pa.setAge(rs.getString("AGE"));
				pa.setBody_temp(rs.getString("BODY_TEMP"));
				pa.setBpm(rs.getString("BPM"));
				pa.setName(rs.getString("NAME"));
				pa.setPatient_room(rs.getString("PATIENT_ROOM"));
				pa.setRespiration(rs.getString("RESPIRATION"));
				pa.setThe_others(rs.getString("THE_OTHERS"));

				datas1.add(pa);

			}
			rs.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return datas1;
	}
	
	public ArrayList<T_Patient_DO> getDBList2() {
		connect();
		ArrayList<T_Patient_DO> datas2 = new ArrayList<T_Patient_DO>();
		
		String sql = "select patientinfo.name,patientinfo.age,medical_record.*,nurse_login.team "
				+ "from patientinfo,medical_record,nurse_login "
				+ "where patientinfo.id = medical_record.id and "
				+ "medical_record.patient_room = '101호' and "
				+ "nurse_login.team = 1 order by patientinfo.id asc";
	
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				T_Patient_DO pp = new T_Patient_DO();

				pp.setId(rs.getInt("ID"));
				pp.setBlood_pressure(rs.getString("BLOOD_PRESSURE"));
				pp.setAge(rs.getString("AGE"));
				pp.setBody_temp(rs.getString("BODY_TEMP"));
				pp.setBpm(rs.getString("BPM"));
				pp.setName(rs.getString("NAME"));
				pp.setPatient_room(rs.getString("PATIENT_ROOM"));
				pp.setRespiration(rs.getString("RESPIRATION"));
				pp.setThe_others(rs.getString("THE_OTHERS"));
				pp.setTeam(rs.getInt("team"));

				datas2.add(pp);

			}
			rs.close();
			
	
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return datas2;
	}
	
	public ArrayList<T_Patient_DO> getDBList3() {
		connect();
		ArrayList<T_Patient_DO> datas3 = new ArrayList<T_Patient_DO>();
		
		String sql = "select patientinfo.name,patientinfo.age,medical_record.*,nurse_login.team "
				+ "from patientinfo,medical_record,nurse_login "
				+ "where patientinfo.id = medical_record.id and "
				+ "medical_record.patient_room = '201호' and "
				+ "nurse_login.team = 2 order by patientinfo.id asc";
	
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				T_Patient_DO pp = new T_Patient_DO();

				pp.setId(rs.getInt("ID"));
				pp.setBlood_pressure(rs.getString("BLOOD_PRESSURE"));
				pp.setAge(rs.getString("AGE"));
				pp.setBody_temp(rs.getString("BODY_TEMP"));
				pp.setBpm(rs.getString("BPM"));
				pp.setName(rs.getString("NAME"));
				pp.setPatient_room(rs.getString("PATIENT_ROOM"));
				pp.setRespiration(rs.getString("RESPIRATION"));
				pp.setThe_others(rs.getString("THE_OTHERS"));
				pp.setTeam(rs.getInt("team"));

				datas3.add(pp);

			}
			rs.close();
			
	
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return datas3;
	}
	
	
	public ArrayList<Patient_Sensor> getSensorList() {
		connect();
		ArrayList<Patient_Sensor> s_datas = new ArrayList<Patient_Sensor>();
		
		String sql = "select * from sensor";
	
		
	
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				Patient_Sensor pp = new Patient_Sensor();

				pp.setTemp(rs.getDouble("TEMP"));
				pp.setBpm(rs.getInt("BPM"));

				s_datas.add(pp);

			}
			rs.close();
			
	
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return s_datas;
	}
	
	public ArrayList<infusion_DO> getInfusionList() {
		connect();
		ArrayList<infusion_DO> i_datas = new ArrayList<infusion_DO>();
		
		String sql = "select * from infusion";
	
	
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				infusion_DO pp = new infusion_DO();

				pp.setId(rs.getInt("ID"));
				pp.setInfusion_name(rs.getString("INFUSION_NAME"));
				pp.setInfsuion_speed(rs.getString("INFUSION_TOTAL_AMOUNT"));
				pp.setInfusion_total_amount(rs.getString("INFUSION_SPEED"));
				pp.setInfusion_reamin_time(rs.getString("INFUSION_REMAIN_TIME"));
				pp.setInfusion_remain_amount(rs.getString("INFUSION_REMAIN_AMOUNT"));
				pp.setDisease(rs.getString("DISEASE"));
				
				i_datas.add(pp);

			}
			rs.close();
			
	
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return i_datas;
	}

}
