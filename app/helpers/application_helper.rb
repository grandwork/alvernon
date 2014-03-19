module ApplicationHelper
  def errors_as_alerts(resource)
    return "" if resource.errors.empty?
    
    if resource.errors.count > 1
      messages = resource.errors.full_messages.map { |msg| msg + "<br/>" }.join.html_safe
    else
      messages = resource.errors.full_messages[0]
    end
    
    # Guess we don't need sentence (1 error prevented User from being sent), so I'll just comment it out
    #sentence = I18n.t("errors.messages.not_saved",
    #                  :count => resource.errors.count,
    #                  :resource => resource.class.model_name.human.downcase)
    
    flash[:alert] = messages
    
    return ""
  end

  def get_generic_report
    [@ut, @et, @visual, @mpi, @pt, @rt].each do |var|
      return var.report if var
    end
  end
  
  def link_to_new_image_fields(report, form_builder)
    new_image = AttachedImage.new
    fields = form_builder.fields_for(:attached_images, new_image, :child_index => "new_attached_image") do |f|
      render :partial => "reports/attached_image_fields", :locals => { :image_form => f } 
    end
    link_to "Add an image to this report", nil, :onclick => "add_image(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end
  
  def link_to_new_mpi_defect_fields(mpi, form_builder)
    new_defect = MpiDefect.new
    fields = form_builder.fields_for(:mpi_defects, new_defect, :child_index => "new_mpi_defect") do |f|
      render :partial => "defects_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a defect to this report'.html_safe, nil, :onclick => "add_mpi_defect(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_et_defect_fields(et, form_builder)
    new_defect = EtDefect.new
    fields = form_builder.fields_for(:et_defects, new_defect, :child_index => "new_et_defect") do |f|
      render :partial => "defects_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a defect to this report'.html_safe, nil, :onclick => "add_et_defect(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_et_probe_fields(mpi, form_builder)
    new_probe = EtProbe.new
    fields = form_builder.fields_for(:et_probes, new_probe, :child_index => "new_et_probe") do |f|
      render :partial => "probes_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a probe to this report'.html_safe, nil, :onclick => "add_et_probe(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_ut_defect_fields(ut, form_builder)
    new_defect = UtDefect.new
    fields = form_builder.fields_for(:ut_defects, new_defect, :child_index => "new_ut_defect") do |f|
      render :partial => "defects_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a defect to this report'.html_safe, nil, :onclick => "add_ut_defect(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_rt_defect_fields(ut, form_builder)
    new_defect = RtDefect.new
    fields = form_builder.fields_for(:rt_defects, new_defect, :child_index => "new_rt_defect") do |f|
      render :partial => "defects_edit_table", :locals => { :f => f } 
    end
    
    link_to "Add a defect to this report", nil, :onclick => "add_rt_defect(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_visual_line_fields(visual, form_builder)
    new_line = VisualLine.new
    fields = form_builder.fields_for(:visual_lines, new_line, :child_index => "new_visual_line") do |f|
      render :partial => "lines_edit_table", :locals => { :f => f } 
    end
    
    link_to "Add another line item to this report", nil, :onclick => "add_visual_line(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "button secondary tiny radius"
  end

  def link_to_new_pt_defect_fields(pt, form_builder)
    new_defect = PtDefect.new
    fields = form_builder.fields_for(:pt_defects, new_defect, :child_index => "new_pt_defect") do |f|
      render :partial => "defects_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a defect to this report'.html_safe, nil, :onclick => "add_pt_defect(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end

  def link_to_new_ut_probe_fields(ut, form_builder)
    new_probe = UtProbe.new
    fields = form_builder.fields_for(:ut_probes, new_probe, :child_index => "new_ut_probe") do |f|
      render :partial => "probes_edit_table", :locals => { :f => f } 
    end
    
    link_to '<i class="icon-plus"></i> Add a probe to this report'.html_safe, nil, :onclick => "add_ut_probe(this, \"#{escape_javascript(fields)}\")", :remote => true, :class => "btn btn-small"
  end
  
  def edit_report_link(report)
    type = report.specific_type.downcase
    link_to "Edit", "/reports/#{type}/#{report.specific.id}/edit", :class => "small_text"   
  end
  
  def delete_report_link(report)
    type = report.specific_type.downcase
    link_to "Delete", "/reports/#{type}/#{report.specific.id}", :confirm => "Are you sure?", :method => :delete, :class => "warning"
  end

  def link_to_new_client_email
    html = render "clients/email_field", email: ''
    link_to '<i class="fa fa-plus"></i> Add Email'.html_safe, '#', onclick: "add_email_field(this, \"#{escape_javascript(html)}\")", class: "button tiny secondary"
  end
  
  def accept_or_reject_class(defect)
    result = ""
    if defect.respond_to?('accept_reject')
      result = "accept" if defect.accept_reject.downcase == 'accept'
      result = "reject" if defect.accept_reject.downcase == 'reject'
    end

    if defect.respond_to?('result')
      result = "accept" if defect.result.downcase == 'accept'
      result = "reject" if defect.result.downcase == 'reject'
    end

    result
  end

  #def reports_count(count)
  #  case count
  #    when 0
  #      "There are no reports for this client."
  #    when 1
  #      "There is one report for this client."
  #    else
  #      "There are #{count} reports for this client."
  #  end
  #end

  def client_user_count
      count = User.where("client_id IS NOT NULL").size
      "Clients (#{count})"
  end




end
