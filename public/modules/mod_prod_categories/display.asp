<!--#include file="../../../core/include/bootstrap.asp" -->
<%
logger.clear
getCategories()
'logger.debug_dump


function getCategories()
	dim rs, result, sql, catid
	set result = new FastString
	dim prodImagePath : prodImagePath = globals("SITEURL") & "/"
	dim prodImgUrl, prodImgAlt
  pid = Request.QueryString("catid")
		trace("mod_prod_categories: selecting active categories...")
		sql="SELECT Key, Active, PID, Category, ShortDescription, LongDescription, Image1 "_
			 & "FROM tblProducts "_
			 & "WHERE Active=True AND((ProductName='') OR (ProductName IS NULL)) "_
			 & "ORDER BY PID, Category;"

		set rs = db.getRecordSet(sql)
		trace("mod_prod_categories: ...done selecting active categories")
		trace("mod_prod_categories: printing categories list to page...")
		dim numCategories : numCategories = 0
		dim prodLink, prodLinkTitle, varclass

		result.add vbCrLf & indent(2) & "<div class=""categorieslist"">" & vbCrLf
		do while not rs.EOF and not rs.BOF
			numCategories = numCategories + 1
			varclass="category clearfix"
			prodLink = "?catid=" & rs("PID")
			prodLinkTitle = "Click for more info about " & rs("Category")
			prodImgUrl = prodImagePath & rs("Image1")
			prodImgAlt = rs("Category")

			if pid=	"" & rs("PID") then varclass = "current " & varclass

  		result.add indent(3) & "<div class=""" & varclass & """>" & vbCrLf
			if not (isempty(rs("Image1")) = true) and (len(trim(rs("Image1"))) > 0) then
				debugInfo("Image1 value is '" & rs("Image1") & "'")
				debugInfo("Checking if image file exists at '" & prodImagePath & rs("Image1") & "'")
				if fileExists(prodImagePath & rs("Image1")) = true then
					result.add indent(4) & anchor(prodLink, img(prodImgUrl, prodImgAlt, prodImgAlt, "product-image"), prodLinkTitle, prodImgAlt & " image") & vbCrLf
				end if
			end if
			result.add indent(4) & "<p>" & vbCrLf
			result.add indent(5) & "<span class=""more-info"">" & anchor(prodLink,"" & rs("Category") & "","Click for more info about " & rs("Category"), null) & "</span>" & vbCrLf
			result.add indent(4) & "</p>" & vbCrLf
			result.add indent(3) & "</div>" & vbCrLf
			rs.movenext
		loop
		result.add indent(3) & "<br clear=""all""/>" & vbCrLf
		result.add indent(2) & "</div>" & vbCrLf
		trace("mod_prod_categories: ...end printing categories list, " & numCategories & " categories listed.")
		numCategories = null
	writeln(result.value)
	set result = nothing
end function
%>
