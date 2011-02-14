import static org.junit.Assert.*;
import org.junit.*;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.regex.Pattern;

import com.gargoylesoftware.htmlunit.BrowserVersion;
import com.gargoylesoftware.htmlunit.MockWebConnection;
import com.gargoylesoftware.htmlunit.WebClient;
import com.gargoylesoftware.htmlunit.html.HtmlElement;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import org.apache.commons.io.FileUtils;

/*
    org.junit.ComparisonFailure:
    Expected :<div id="drop_2" class="drop ui-droppable"></div>
    Actual   :<div id="drop_1" class="drop ui-droppable"></div>
*/

public class HtmlUnitTest {
    protected WebClient client;
    protected MockWebConnection connection;

    public HtmlUnitTest() throws Exception {
        client = new WebClient(BrowserVersion.FIREFOX_3);
        connection = new MockWebConnection();
    }

    @Test
    public void testDragAndDrop () throws Exception {
        client.setWebConnection(connection);

        mockResponse("index.html", "text/html");
        mockResponse("jquery.js", "application/javascript");
        mockResponse("jquery-ui.js", "application/javascript");

        HtmlPage page = client.getPage("http://localhost/index.html");
        HtmlElement drag = (HtmlElement) page.getByXPath("//div[contains(@class, 'drag')]").get(0);
        HtmlElement drop = (HtmlElement) page.getByXPath("//div[@id='drop_2']").get(0);

        drag.mouseDown();
        drop.mouseMove();
        page = (HtmlPage) drop.mouseUp();
        client.waitForBackgroundJavaScript(1000);

        String log = page.executeJavaScript("$('#log').text()").getJavaScriptResult().toString();
        assertEquals("<div id=\"drop_2\" class=\"drop ui-droppable\"></div>", log);
    }

    public void mockResponse(String path, String contentType) throws Exception {
        URL url = new URL("http://localhost/" + path);
        connection.setResponse(url, readFile(path), contentType);
    }

    public String readFile(String name) throws IOException {
        return FileUtils.readFileToString(new File(name));
    }

}
