Global Class AutoConvertLeads implements Schedulable{
    global void execute(SchedulableContext SC)
    {
            Integer numberOfConvertLeads = integer.ValueOf(Label.NumberOfConvertLeads);
            DateTime now = System.now();
            DateTime ConvertDateTime = now.addMinutes(integer.ValueOf(Label.MinutesToWaitToConvert) *(-1));
            List<LeadConvertTypes__mdt> generalCmdt = [SELECT ConvertCaregiver__c, ConvertDoctor__c, ConvertDoctorsSurgery__c, ConvertHealthcareInstitution__c FROM LeadConvertTypes__mdt LIMIT 1];
            
            String[] TypesToConvert = new String[]{''};
            if(generalCmdt[0].ConvertCaregiver__c){ TypesToConvert.add('Caregiver');}
            if(generalCmdt[0].ConvertDoctor__c){ TypesToConvert.add('Doctor');}
            if(generalCmdt[0].ConvertHealthcareInstitution__c ){ TypesToConvert.add('Healthcare Institution');}
            if(generalCmdt[0].ConvertDoctorsSurgery__c) { TypesToConvert.add('Doctors Surgery');} 
            
                                    
            List<Lead> Leads =  [SELECT Id, Status FROM Lead WHERE AccountRecordType__c IN :TypesToConvert AND (Status='Neu' OR Status='New') AND CreatedDate < :ConvertDateTime LIMIT :numberOfConvertLeads];
            LeadStatus LeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            List<Lead> NotConvertableLeads = new List<Lead>();
            
            for (Lead currentLead : Leads) {
                try {
                    Database.LeadConvert Leadconvert = new Database.LeadConvert();
                    Leadconvert.setLeadId(currentLead.Id);
                    Leadconvert.setConvertedStatus(LeadStatus.MasterLabel);
                    Leadconvert.setDoNotCreateOpportunity(TRUE);
                    Database.LeadConvertResult Leadconverts = Database.convertLead(Leadconvert);
                    System.assert(Leadconverts.isSuccess());
                } catch(Exception e) {
                    currentLead.Status = Label.LeadStatusNichtKonvertierbar; 
                    NotConvertableLeads.add(currentLead);
                }
            }
            update NotConvertableLeads;
   }
}