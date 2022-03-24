---
title: iText学习
categories:
  - iText
date: 2020-01-05 23:21:01
tags:
  - iText
  - 排版
---


<a name="X2pDY"></a>
# 页眉与页脚

iText5中并没有之前版本HeaderFooter对象设置页眉和页脚，可以利用PdfPageEventHelper来完成页眉页脚的设置工作。PdfPageEventHelper中包含以下事件处理器。

```
onOpenDocument() — 当打开一个文档时触发，可以用于初始化文档的全局变量。
onStartPage() — 当一个页面初始化时触发，可用于初始化页面的设置参数，但是注意这个函数触发时，该页面并没有创建好，不用利用这个函数添加内容，最好利用onEndPage()处理页面的初始化。
onEndPage() — 在创建一个新页面完成但写入内容之前触发，是添加页眉、页脚、水印等最佳时机。
onCloseDocument() — 在文档关闭之前触发，可以用于释放一些资源。
onCloseDocument() — 在文档关闭之前触发，可以用于释放一些资源。
```

要想出发事件需要在程序中添加事件

如下

```
PdfReportM1HeaderFooter footer=new PdfReportM1HeaderFooter();
writer.setPageEvent(footer);
```

该类PdfReportM1HeaderFooter继承自PdfPageEventHelper所以可以直接添加、

```java

package demo;

/**
 * Project Name:report
 * File Name:PdfReportM1HeaderFooter.java
 * Package Name:com.riambsoft.report.pdf
 * Date:2013-9-16上午08:59:00
 * Copyright (c) 2013, riambsoft All Rights Reserved.
 *
 */

import java.io.IOException;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;

/**
 * ClassName:PdfReportM1HeaderFooter <br/>
 * Function: TODO ADD FUNCTION. <br/>
 * Reason: TODO ADD REASON. <br/>
 * Date: 2013-9-13 上午08:59:00 <br/>
 *
 * @author 落雨
 * @version 394263788(QQ)
 * @since JDK 1.5
 * @see http://hi.baidu.com/ae6623
 */
public class PdfReportM1HeaderFooter extends PdfPageEventHelper {

    /**
     * 页眉
     */
    public String header = "";

    /**
     * 文档字体大小，页脚页眉最好和文本大小一致
     */
    public int presentFontSize = 12;

    /**
     * 文档页面大小，最好前面传入，否则默认为A4纸张
     */
    public Rectangle pageSize = PageSize.A4;

    // 模板
    public PdfTemplate total;

    // 基础字体对象
    public BaseFont bf = null;

    // 利用基础字体生成的字体对象，一般用于生成中文文字
    public Font fontDetail = null;

    /**
     *
     * Creates a new instance of PdfReportM1HeaderFooter 无参构造方法.
     *
     */
    public PdfReportM1HeaderFooter() {

    }

    /**
     *
     * Creates a new instance of PdfReportM1HeaderFooter 构造方法.
     *
     * @param yeMei           页眉字符串
     * @param presentFontSize 数据体字体大小
     * @param pageSize        页面文档大小，A4，A5，A6横转翻转等Rectangle对象
     */
    public PdfReportM1HeaderFooter(String yeMei, int presentFontSize, Rectangle pageSize) {
        this.header = yeMei;
        this.presentFontSize = presentFontSize;
        this.pageSize = pageSize;
    }

    public void setHeader(String header) {
        this.header = header;
    }

    public void setPresentFontSize(int presentFontSize) {
        this.presentFontSize = presentFontSize;
    }

    /**
     *
     * TODO 文档打开时创建模板
     *
     * @see com.itextpdf.text.pdf.PdfPageEventHelper#onOpenDocument(com.itextpdf.text.pdf.PdfWriter,
     *      com.itextpdf.text.Document)
     */
    public void onOpenDocument(PdfWriter writer, Document document) {
        total = writer.getDirectContent().createTemplate(50, 50);// 共 页 的矩形的长宽高
    }

    /**
     *
     * TODO 关闭每页的时候，写入页眉，写入'第几页共'这几个字。
     *
     * @see com.itextpdf.text.pdf.PdfPageEventHelper#onEndPage(com.itextpdf.text.pdf.PdfWriter,
     *      com.itextpdf.text.Document)
     */
    public void onEndPage(PdfWriter writer, Document document) {

        try {
            if (bf == null) {
                bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", false);
            }
            if (fontDetail == null) {
                fontDetail = new Font(bf, presentFontSize, Font.NORMAL);// 数据体字体
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 1.写入页眉
        ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_LEFT, new Phrase(header, fontDetail),
                document.left(), document.top() + 20, 0);

        // 2.写入前半部分的 第 X页/共
        int pageS = writer.getPageNumber();
        String foot1 = "第 " + pageS + " 页 /共";
        Phrase footer = new Phrase(foot1, fontDetail);

        // 3.计算前半部分的foot1的长度，后面好定位最后一部分的'Y页'这俩字的x轴坐标，字体长度也要计算进去 = len
        float len = bf.getWidthPoint(foot1, presentFontSize);

        // 4.拿到当前的PdfContentByte
        PdfContentByte cb = writer.getDirectContent();

        // 自己增加的
        if (pageS == 1) {
            Phrase footerLeft = new Phrase("978-1-4799-0530-031.00 ©2013 IEEE", fontDetail);
            ColumnText.showTextAligned(cb, Element.ALIGN_LEFT, footerLeft, document.left(), document.bottom() - 20, 0);
        }

        // 5.写入页脚1，x轴就是(右margin+左margin + right() -left()- len)/2.0F
        // 再给偏移20F适合人类视觉感受，否则肉眼看上去就太偏左了
        // ,y轴就是底边界-20,否则就贴边重叠到数据体里了就不是页脚了；注意Y轴是从下往上累加的，最上方的Top值是大于Bottom好几百开外的。
        ColumnText.showTextAligned(cb, Element.ALIGN_CENTER, footer,
                (document.rightMargin() + document.right() + document.leftMargin() - document.left() - len) / 2.0F
                        + 20F,
                document.bottom() - 20, 0);

        // 6.写入页脚2的模板（就是页脚的Y页这俩字）添加到文档中，计算模板的和Y轴,X=(右边界-左边界 - 前半部分的len值)/2.0F + len ， y
        // 轴和之前的保持一致，底边界-20
        cb.addTemplate(total,
                (document.rightMargin() + document.right() + document.leftMargin() - document.left()) / 2.0F + 20F,
                document.bottom() - 20); // 调节模版显示的位置

    }

    /**
     *
     * TODO 关闭文档时，替换模板，完成整个页眉页脚组件
     *
     * @see com.itextpdf.text.pdf.PdfPageEventHelper#onCloseDocument(com.itextpdf.text.pdf.PdfWriter,
     *      com.itextpdf.text.Document)
     */
    public void onCloseDocument(PdfWriter writer, Document document) {
        // 7.最后一步了，就是关闭文档的时候，将模板替换成实际的 Y 值,至此，page x of y 制作完毕，完美兼容各种文档size。
        total.beginText();
        total.setFontAndSize(bf, presentFontSize);// 生成的模版的字体、颜色
        String foot2 = " " + (writer.getPageNumber() - 1) + " 页";
        total.showText(foot2);// 模版显示的内容
        total.endText();
        total.closePath();
    }
}
```


<a name="A3JNH"></a>
# 页边距

Isn't it possible for you to use HtmlConverter#convertToElements method. It returns List as a result and then you can add its elements to a document with set margins:

```java
Document document = new Document(pdfDocument);
List list = HtmlConverter.convertToElements(new FileInputStream(htmlSource));
for (IElement element : list) {
if (element instanceof IBlockElement) {
document.add((IBlockElement) element);
}
}
```

Another approach: in your html just introduce the [@page ]() rule which sets the margins you need, for example:

```css
@page {margin: 0;}
```

Yet another solution: implement your own custom tag worker for  tag and set margins on its level. For example, to set zero margins one could create tag the next worker:

```java
public class CustomTagWorkerFactory extends DefaultTagWorkerFactory {
public ITagWorker getCustomTagWorker(IElementNode tag, ProcessorContext context) {
if (TagConstants.HTML.equals(tag.name())) {
return new ZeroMarginHtmlTagWorker(tag, context);
}
return null;
}
}
public class ZeroMarginHtmlTagWorker extends HtmlTagWorker {
public ZeroMarginHtmlTagWorker(IElementNode element, ProcessorContext context) {
super(element, context);
Document doc = (Document) getElementResult();
doc.setMargins(0, 0, 0, 0);
}
}
```

and pass it as a ConverterProperties parameter to Htmlconverter:

converterProperties.setTagWorkerFactory(new CustomTagWorkerFactory());<br />HtmlConverter.convertToPdf(new File(htmlPath), new File(pdfPath), converterProperties);

<a name="JVj2m"></a>
# 表格跨页问题

<a name="F5KRY"></a>
## 代码的处理方式

![](http://depot.wanqiang.wang/blog/20200113/uV2yCxzGTvUH.png?imageslim)

<a name="TTEFI"></a>
## pdfHtml的一种处理方式

I had a similar issue of trying to keep together content within a div. I applied the following css property and this kept everything together. This worked with itext7 pdfhtml.

```css
page-break-inside: avoid;
```


<a name="nDdia"></a>
# PdfPage转换成图片

<a name="EeYSn"></a>
## 生成image对象
[https://stackoverflow.com/questions/37809019/itext7-pdf-to-image](https://stackoverflow.com/questions/37809019/itext7-pdf-to-image)

Please read the official documentation for iText 7, more specifically [Chapter 6: Reusing existing PDF documents](http://developers.itextpdf.com/content/itext-7-jump-start-tutorial/chapter-6-reusing-existing-pdf-documents)<br />In PDF, there's the concept of _Form XObject_s. A _Form XObject_ is a piece of PDF content that is stored outside the content stream of a page, hence XObject which stands for eXternal Object. The use of the word _Form_ in _Form XObject_ could be confusing, because people might be thinking of a form as in a fillable form with fields. To avoid that confusing, we introduced the term `PdfTemplate` in iText 5.<br />The class `PdfImportedPage` you refer to was a subclass of `PdfTemplate`: it was a piece of PDF syntax that could be reused in another page. Over the years, we noticed that people also got confused by the word `PdfTemplate`.<br />In iText 7, we returned to the basics. When talking about a Form XObject, we use the class `PdfFormXObject`. When talking about a page in a PDF file, we use the class `PdfPage`.<br />This is how we get a `PdfPage` from an existing document:
```java
PdfDocument origPdf = new PdfDocument(new PdfReader(src));
PdfPage origPage = origPdf.getPage(1);
```
This is how we use that page in a new document:
```java
PdfDocument pdf = new PdfDocument(new PdfWriter(dest));
PdfFormXObject pageCopy = origPage.copyAsFormXObject(pdf);
```
If you want to use that `pageCopy` as an `Image`, just create it like this:
```java
Image image = new Image(pageCopy);
```

<a name="AE5AO"></a>
## 存成图片(验证了这种方法不可行)
[https://stackoverflow.com/questions/24940813/saving-com-itextpdf-text-image-as-a-image-file](https://stackoverflow.com/questions/24940813/saving-com-itextpdf-text-image-as-a-image-file)<br />Just convert the Barcode39 itext image into an AWT image using [createAwtImage](http://api.itextpdf.com/itext/com/itextpdf/text/pdf/Barcode39.html#createAwtImage(java.awt.Color,%20java.awt.Color)):
```java
java.awt.Image awtImage = code39.createAwtImage(Color.BLACK, Color.WHITE);
```
Then convert it to a `BufferedImage` and store it:
```java
BufferedImage bImage= new BufferedImage(awtImage.getWidth(), awtImage.getHeight(), BufferedImage.TYPE_INT_RGB);
Graphics2D g = bImage.createGraphics();
g.drawImage(awtImage, 0, 0, null);
g.dispose();
File outputfile = new File("saved.png");
ImageIO.write(bImage, "jpg", new File("code39.jpg"));
```

