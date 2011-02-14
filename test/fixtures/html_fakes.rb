module HtmlFakes
  def html(options = {})
    fields  = Array(options[:fields]).map { |field| self.send(field) }
    scripts = Array(options[:scripts]).map { |script| self.send(script) }
    ERB.new(layout).result(binding)
  end

  def text
    <<-html
      <label for="field">Label for field</label>
      <input type="text" id="field" name="field" />
    html
  end

  def textarea
    <<-html
      <label for="textarea">Label for textarea</label>
      <textarea id="textarea" name="textarea"></textarea>
    html
  end

  def checkbox
    <<-html
      <label for="checkbox">Label for checkbox</label>
      <input id="checkbox" type="checkbox" name="checkbox" value="1" />
    html
  end

  def radio
    <<-html
      <label for="radio1">Label for radio</label>
      <input id="radio1" type="radio" name="radio" value="radio" />
      <label for="radio2">Label for tv</label>
      <input id="radio2" type="radio" name="radio" value="tv" />
    html
  end

  def select
    <<-html
      <label for="select">Label for select</label>
      <select id="select" name="select">
        <option value=""></option>
        <option value="foo">foo</option>
      </select>
    html
  end

  def hidden
    <<-html
      <input id="hidden" type="hidden" name="hidden" value="bar" />
    html
  end

  def file
    <<-html
      <label for="file">Label for file</label><input id="file" type="file" name="file" />
    html
  end

  def date
    <<-html
      <label for="event_date">Date</label>
      <select id="event_date_1i" name="event_date(1i)">
        <option value="2008">2008</option>
        <option value="2009">2009</option>
        <option value="2010">2010</option>
      </select>
      <select id="event_date_2i" name="event_date(2i)">
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
      </select>
      <select id="event_date_3i" name="event_date(3i)">
        <option value="6">6</option>
        <option value="7">7</option>
        <option value="8">8</option>
      </select>
    html
  end

  def datetime
    <<-html
      <label for="event_datetime">Datetime</label>
      <select id="event_datetime_1i" name="event_datetime(1i)">
        <option value="2008">2008</option>
        <option value="2009">2009</option>
        <option value="2010">2010</option>
      </select>
      <select id="event_datetime_2i" name="event_datetime(2i)">
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
      </select>
      <select id="event_datetime_3i" name="event_datetime(3i)">
        <option value="6">6</option>
        <option value="7">7</option>
        <option value="8">8</option>
      </select> : 
      <select id="event_datetime_4i" name="event_datetime(4i)">
        <option value="18">18</option>
        <option value="19">19</option>
        <option value="20">20</option>
      </select>
      <select id="event_datetime_5i" name="event_datetime(5i)">
        <option value="0">00</option>
        <option value="1">01</option>
        <option value="2">02</option>
      </select>
    html
  end

  def time
    <<-html
      <label for="event_time">Time</label>
      <select id="event_time_4i" name="event_time(4i)">
        <option value="18">18</option>
        <option value="19">19</option>
        <option value="20">20</option>
      </select>
      <select id="event_time_5i" name="event_time(5i)">
        <option value="0">00</option>
        <option value="1">01</option>
        <option value="2">02</option>
      </select>
    html
  end

  def jquery
    <<-html
      <script src="/javascripts/jquery.js" type="text/javascript"></script>
    html
  end

  def jquery_ui
    <<-html
      <script src="/javascripts/jquery-ui.js" type="text/javascript"></script>
    html
  end

  def foo
    <<-html
      <script src="/javascripts/foo.js" type="text/javascript"></script>
    html
  end

  def hover
    <<-html
      <script src="/javascripts/hover.js" type="text/javascript"></script>
    html
  end

  def blur
    <<-html
      <script src="/javascripts/blur.js" type="text/javascript"></script>
    html
  end

  def focus
    <<-html
      <script src="/javascripts/focus.js" type="text/javascript"></script>
    html
  end

  def double_click
    <<-html
      <script src="/javascripts/double_click.js" type="text/javascript"></script>
    html
  end

  def drag
    <<-html
      <script src="/javascripts/drag.js" type="text/javascript"></script>
    html
  end

  def layout
    <<-erb
      <html>
        <head><%= scripts %></head>
        <body>
          <p id="paragraph"></p>
          <p><a href="/link" id="link">link</a></p>
          <form action="/form" method="get" id="form" enctype="multipart/form-data">
            <%= fields %>
            <input type="submit" value="button" />
          </form>
        </body>
      </html>
    erb
  end
end