class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

   before_filter :authorize, only: [:index, :destroy, :new, :show], :except => :new_session_path
  # GET /appointments
  # GET /appointments.json
  def index
    @appointments1 = Appointment.where(section: 'Mock_1').order(:time_slot)

    @appointments2 = Appointment.where(section: 'Mock_2').order(:time_slot)
    @appointments3 = Appointment.where(section: 'Resume_1').order(:time_slot)
    @appointments4 = Appointment.where(section: 'Resume_2').order(:time_slot)
    @appointments5 = Appointment.where(section: 'Resume_3').order(:time_slot)
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  helper_method :generate

  def generate
    @studentfinish = []
    @errormessage = ["Error timeslot Below:"]
    Appointment.delete_all
    #matchapp('11:30am-12:30am','Mock_1')
    matchappsection('Mock Interview 1')
    matchappsection('Mock Interview 2')
    matchappsection('Resume Clinic 1')
    matchappsection('Resume Clinic 2')
    matchappsection('Resume Clinic 3')
    flag = 0
    puts 'check if all student finish'
    print @studentfinish
    @studentfinish.each do |x|
  if x == true
  flag = 1; 
      
  end
    end
    if flag == 0
      redirect_to appointments_url, notice: 'Appointment was successfully generated.'
    else 
      redirect_to appointments_url, notice: 'Appointment was successfully generated, however lack of company, some student failed, check your company status' 
  #flash[:notice] =  "Appointment was generated, Some students failed to generate an appointment due to the lack of campany represents for the following time slots"
  flash[:notice] = @errormessage
    end 
 end


################################################################ 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:section, :time_slot, :company, :student, :UIN)
    end

###############################################################
    def matchappsection(mock)
  
  case mock 
    when "Mock Interview 1"
      mockselect = 'Mock_1' 
    when "Mock Interview 2"
      mockselect = 'Mock_2' 
    when "Resume Clinic 1"
      mockselect = 'Resume_1' 
    when "Resume Clinic 2"
      mockselect = 'Resume_2' 
    when "Resume Clinic 3"
      mockselect = 'Resume_3' 
    else
  end
  slot = Timeslot.where("section= ?", "#{mock}").collect {|x| x.slot}
  puts 'print time slot'
  puts slot
  slot.each do |arg|
    puts 'current select'
    puts arg
    puts ' '
    matchapp(arg, mockselect)
    #matchapp('11:30am-12:30am', mockselect)
  end
    end


###############################################################
    def matchapp(arg, mock)
    
  @student
case mock
  when "Mock_1"
  @student =  Student.where(Mock_1: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
  when "Mock_2"
  @student =  Student.where(Mock_2: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
  when "Resume_1"
  @student =  Student.where(Resume_1: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
  when "Resume_2"
  @student =  Student.where(Resume_2: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
  when "Resume_3"
  @student =  Student.where(Resume_3: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
  else
  @student =  Student.where(Mock_1: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}
end

case mock
    when "Mock_1"
    selforcom="intvw_1_rep_no"
    when "Mock_2"
    selforcom="intvw_2_rep_no"
    when "Resume_1"
    selforcom="clinic_1_rep_no"
    when "Resume_2"
    selforcom="clinic_2_rep_no"
    when "Resume_3"
    selforcom="clinic_3_rep_no" 
    else
    selforcom="intvw_1_rep_no"
end

    @companyplat = Company.where("sponsor_level = ? AND #{selforcom} > 0 ", 'Platinum').collect {|item| [item.name, item.job_type, item.student_level, item.citizenship, item.send(selforcom)]}
    @companygold = Company.where("sponsor_level = ? AND #{selforcom} > 0 ", 'Gold').collect {|item| [item.name, item.job_type, item.student_level, item.citizenship, item.send(selforcom)]}
    @companysilver = Company.where("sponsor_level = ? AND #{selforcom} > 0 ", 'Silver').collect {|item| [item.name, item.job_type, item.student_level, item.citizenship, item.send(selforcom)]}


    if @companyplat.length>0 && @student.length>0
      matchappoint(arg, mock, @companyplat) 
    end

    if @companygold.length>0 && @student.length>0 
    matchappoint(arg, mock, @companygold)
    end

    if @companysilver.length>0 && @student.length>0
      matchappoint(arg, mock, @companysilver)
    end

    @comremain = @companyplat + @companygold + @companysilver 
#    puts 'this is the remain company information'
#    print @comremain
    @comremain.delete_if{|x| x[4]<=0}
#    puts 'remain company information have people'
#    print @comremain
    if @comremain.length>0 && @student.length>0 
    matchappointwithout(arg, mock, @comremain)   
    end
    finish = @student.length>0 
    if @student.length > 0
    error = "#{mock}"+ ':  '+ "#{arg}" 
    #error = arg
    @errormessage << error 
    end
    @studentfinish << finish
    end


##############################################################
def matchappointwithout(arg, mock, company)
      stuuin=[];
      totalrep = 0;        
    company.each { |com| totalrep+=com[4]}
    #puts 'print all all the remain rep number'
    #print totalrep
    #puts ' '
    while @student.length > 0 && totalrep> 0 do
      @student.each do |student|
       company.each do |item|
          if item[4] > 0 
            appointment = Appointment.new
            getone = student      
            appointment.section = mock
            appointment.time_slot = getone[5]
            appointment.company = item[0]
            appointment.student = getone[1]
            appointment.UIN = student[0]
      stuuin = stuuin << getone[0]
            item[4]-=1
      totalrep-=1
            appointment.save
           break  
          end        
        end
      end
  stuuin.each do |uin|
       @student.delete_if {|x| x[0]==uin}
  end
    end
    
end


###############################################################
    def matchappoint(arg, mock, company)
      stuuin=[]; 
      @student.each do |student|
       company.each do |item|

###############################添加一下for any的情况###############
# @student =  Student.where(Resume_3: arg).collect {|item| [item.UIN, item.name, item.degree, item.position_type, item.US_Citizen, item.send(mock)]}

#   @companysilver = Company.where("sponsor_level = ? AND #{selforcom} > 0 ", 'Silver').collect {|item| [item.name, item.job_type, item.student_level, item.citizenship, item.send(selforcom)]}
###################################################################

      usif= item[3]=="US Citizen Only"? true:false
      conjobtype = item[1] == student[3] || item[1] == 'any' || item[1] == nil
      condegree = item[2] == student[2] || item[2] == 'any' || item[2] == nil 
      concitizen = usif == student[4] || usif == false || usif == nil

      if (item[4] > 0 && conjobtype && condegree && concitizen)
      getone = student
     
            appointment = Appointment.new
            appointment.section = mock
            appointment.time_slot = getone[5]
            appointment.company = item[0]
            appointment.student = getone[1]
            appointment.UIN = getone[0]
            stuuin = stuuin << getone[0]
      item[4]-=1
            appointment.save
      break
            end
        end
      end
  stuuin.each do |uin|
       @student.delete_if {|x| x[0]==uin}
  end
    end
  ################################################################
end