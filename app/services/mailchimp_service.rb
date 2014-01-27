class MailchimpService
  LIST_ID = 'd930f63095' #Sosi list
  GROUP_ID = 2125 # SosiRole

  # Gibbon usus MAILCHIMP_API_KEY from ENV if nil supplied
  def initialize(api_key = nil)
    @gibbon = Gibbon.new(api_key)
  end

  def subscribe_user_to_list(user, group_name='User')
    @gibbon.list_subscribe({id: LIST_ID, 
                            email_address: user.email,
                            update_existing: true,
                            double_optin: false,
                            send_welcome: false,
                            merge_vars: { FNAME: user.first_name,
                                          LNAME: user.last_name,
                                          GROUPINGS: {0 => {id: GROUP_ID,
                                                            groups: group_name}}}})
  end

  def subscribe_email_to_list(email, group_name='NewsletterOnly')
    @gibbon.list_subscribe({id: LIST_ID, 
                            email_address: email,
                            merge_vars: { GROUPINGS: {0 => {id: GROUP_ID,
                                                            groups: group_name}}}})
  end
end