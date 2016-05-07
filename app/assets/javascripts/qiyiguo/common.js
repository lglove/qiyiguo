//第一页改变背景
$(document).ready(function(){

  var backgrounds = [];
  var text = [];
  var header = $('.bag1');
  var headline = $('');
  var index=0;

  backgrounds[0] = 'bag1';
  backgrounds[1] = 'bag2';
  backgrounds[2] = 'bag3';

  text[0] = '纠结半天，又没买到衣服';
  text[1] = '买衣服太浪费时间了';
  text[2] = '看过很多达人分享，却依然穿不好这一身';

  function changeBackground() {
    index++;
    if(index%3==0){
      header.removeClass().fadeIn(2000,function(){$(this).addClass(backgrounds[0]);});
      headline.html(text[0]);
    }else if(index%3==1){
      header.removeClass().fadeIn(2000,function(){$(this).addClass(backgrounds[1]);});
      headline.html(text[1]);
    }else{
      header.removeClass().fadeIn(2000,function(){$(this).addClass(backgrounds[2]);});
      headline.html(text[2]);
    }
  }
  setInterval(changeBackground, 4000);
})

$(function(){
  //滚动时改变导航背景颜色
  $(window).scroll(function(){
    if($(document).scrollTop()>50){
      $("nav").addClass("on");
    }else{
      $("nav").removeClass("on");
    }
  })
})

//点击logo返回顶部
$(function(){
  $("#top").click(function() {
    $("html,body").animate({scrollTop:0}, 500);
  });
})
