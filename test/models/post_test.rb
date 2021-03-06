require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @post = posts(:one)
  end

  test "published" do
    @post.published_date = 1.day.ago
    assert @post.published?, "Post was not published"
    @post.published_date = 1.day.from_now
    refute @post.published?, "Post was published"
  end

  test "handle changes on save" do
    handle = @post.handle
    @post.title = "This is a brand new title"
    @post.save
    assert_not_equal handle, @post.handle
    assert_equal "this-is-a-brand-new-title", @post.handle
  end

  test "html_body" do
    expected = """
    <div id=\"post-body\"><p class=\"p1\">I've been learning, although sometimes a little bit randomly, over the past few weeks. I'm curious if the course content in class, which is largely obvious or review, is taking a lot of my \"thought time\" (how much I'm able to mentally process in a day before becoming tired). I find my yearning for more, wanting to improve, but sometimes its as if I'm too tired to make that jump. Let's see if I can work on that for next week's post.</p><p class=\"p1\"><b><br></b></p><p class=\"p1\"><b>Jan 18</b></p>
    <p class=\"p1\">There’s a second smaller canyon in the area of the Grand Canyon, as well as a cool ghost town. (I’m being liberal and saying 4 hour driving radius is within the area).</p>
    <p class=\"p1\"><b>Jan 19</b></p>
    <p class=\"p1\">You can get all basic regex operators through the use of + (or), * (0 or more) and parentheses.&nbsp;</p>
    <p class=\"p1\"><b>Jan 20</b></p>
    <p class=\"p1\">We can start AI systems with simple decision trees.</p>
    <p class=\"p1\">I had something else here, but I forgot to write it down, so I suppose today’s thing I learned is to write stuff down, damnit.</p>
    <p class=\"p1\"><b>Jan 21</b></p>
    <p class=\"p1\">Linear algebra can be used for indexing and searching, actually that is what is used. Linear Algebra will come in handy (finally).</p>
    <p class=\"p1\"><b>Jan 22</b></p>
    <p class=\"p1\">Sentiment Analysis is a type of machine learning / AI that can analyze a text and “assign” an emotion to it (think happy, sad etc). By analyzing the content, especially in the context of the other words (intratexuality if you will), we can easily determine the meaning behind words.</p>
    <p class=\"p1\"><b>Jan 23</b></p>
    <p class=\"p1\">Quick conversations can often lead you down a completely different path in whatever you are working on, sometimes for the better and sometimes for worse. If you are researching, remember that risk aversion may negatively affect you.</p>
    <p class=\"p1\"><b>Jan 24</b></p>
    <p class=\"p1\">Reorganizing and cleaning can be a good stress reliever and really help you later on.&nbsp;</p>
    <p class=\"p1\">Random days at the theatres are the best.</p>
    <p class=\"p1\"><b>Jan 25</b></p>
    <p class=\"p1\">When purchasing from an online store, make sure you check how they handle in-store exchanges and replacements.</p>
    </div>
    """
    assert_equal expected.gsub(/\s+/, ""), @post.html_body.gsub(/\s+/, "")
  end

  test "trancated_body" do
    expected = """
    <div id=\"post-body\">
    <p class=\"p1\">I've been learning, although sometimes a little bit randomly, over the past few weeks. I'm curious if the course content in class, which is largely obvious or review, is taking a lot of my \"thought time\" (how much I'm able to mentally process in a day before becoming tired). I find my yearning for more, wanting to improve, but sometimes its as if I'm too tired to make that jump. Let's see if I can work on that for next week's post.</p>
    <p class=\"p1\"><b><br></b></p>
    <p class=\"p1\"><b>Jan 18</b></p>
    <p class=\"p1\">There’s a second smaller canyon in the area of the Grand Canyon, as well as a cool ghost town. (I’m being liberal and saying 4 hour driving radius is within the area).</p>
    <p class=\"p1\"><b>Jan 19</b></p>
    <p class=\"p1\">You can get all basic regex operators through the use of + (or), * (0 or more) and parentheses. </p>
    <p class=\"p1\"><b>Jan 20</b></p>
    <p class=\"p1\">We can start AI systems with simple decision trees.</p>
    <p class=\"p1\">I had something else here, but I forgot to write it down, so I suppose today’s thing I learned is to write stuff down, damnit.</p>
    <p class=\"p1\"><b>Jan 21</b></p>
    <p class=\"p1\">Linear algebra can be used for indexing and searching, actually that is what is used. Linear Algebra will come in handy (finally).</p>
    <p class=\"p1\"><b>Jan 22</b></p>
    <p class=\"p1\">Sentiment...</p>
    </div>
    """
    assert_equal expected.gsub(/\s+/, ""), @post.trancated_body.gsub(/\s+/, "")
  end
end
