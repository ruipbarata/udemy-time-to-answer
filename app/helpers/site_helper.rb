module SiteHelper

  def msg_jumbotron
    case params[:action]
    when "index"
      "Últimas perguntas registadas..."
    when "question"
      "Resultados para o termo \"#{params[:term]}\"..."
    when "subject"
      "Perguntas para o assunto \"#{params[:subject]}\"..."
    end
  end

end
