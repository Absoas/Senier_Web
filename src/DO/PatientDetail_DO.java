package DO;

public class PatientDetail_DO {

	int id;
	String patient_room;
	int bpm;
	double body_temp;	
	int respiration;
	int blood_pressure;
	String the_others;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getPatient_room() {
		return patient_room;
	}
	public void setPatient_room(String patient_room) {
		this.patient_room = patient_room;
	}
	public int getBpm() {
		return bpm;
	}
	public void setBpm(int bpm) {
		this.bpm = bpm;
	}
	public double getBody_temp() {
		return body_temp;
	}
	public void setBody_temp(double body_temp) {
		this.body_temp = body_temp;
	}
	public int getRespiration() {
		return respiration;
	}
	public void setRespiration(int respiration) {
		this.respiration = respiration;
	}
	public int getBlood_pressure() {
		return blood_pressure;
	}
	public void setBlood_pressure(int blood_pressure) {
		this.blood_pressure = blood_pressure;
	}
	public String getThe_others() {
		return the_others;
	}
	public void setThe_others(String the_others) {
		this.the_others = the_others;
	}
	
}
