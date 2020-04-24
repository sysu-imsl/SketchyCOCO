function onClick(arg) {
    var data_ = arg.getAttribute('data');
    var data_type = arg.getAttribute('data-type');
    var output = document.getElementById("output");
    var sketch_path = '';
    var gt_path = '';
    var json_path = '';
    var result_array = [];
    if (data_ == "Objects") {
        sketch_path = 'Object/Sketch/';
        gt_path = 'Object/GT/';
        json_path = 'https://cdn.jsdelivr.net/gh/sysu-imsl/CDN-for-SketchyCOCO@v1.0/Object.json'
    } else {
        sketch_path = 'images/Scene/Sketch/';
        gt_path = 'Scene/GT/';
        json_path = 'https://cdn.jsdelivr.net/gh/sysu-imsl/CDN-for-SketchyCOCO@v1.0/Scene.json'
    }
    $.ajax({
        type:'get',
        url:json_path,
        dataType:'json',
        success:function(data){
            console.log(data_type)
            if (data_ == "Objects") {
                var tmp = data[data_type.toString()]
            } else {
                var tmp = data.data;
            }
            // console.log(tmp)
            var counter = 0;
            var index = 0;
            var pre_head = "https://cdn.jsdelivr.net/gh/sysu-imsl/CDN-for-SketchyCOCO@v1.0/data/";
            for (var n = 0; n<tmp.length; n++) {
                path = tmp[n];
                if (counter % 2 == 0 && counter != 0) {
                    result_array.push("        </tr>\n        <tr>\n          <td>\n            <a href=" + pre_head + sketch_path + path + ">" + "<img src=" + pre_head + sketch_path + path +  " alt=\"\" /></div></a>" + "\n       </td>");
                    result_array.push("          <td>\n            <a href=" + pre_head + gt_path + path + ">" + "<img src=" + pre_head + gt_path + path +  " alt=\"\" /></div></a>" + "\n       </td>");
                } else {
                    result_array.push("          <td>\n            <a href=" + pre_head + sketch_path + path + ">" + "<img src=" + pre_head + sketch_path + path +  " alt=\"\" /></div></a>" + "\n       </td>");
                    result_array.push("          <td>\n            <a href=" + pre_head + gt_path + path + ">" + "<img src=" + pre_head + gt_path + path +  " alt=\"\" /></div></a>" + "\n       </td>");
                    if (counter != 0) {
                        result_array.push("        <tr>\n         <td>sketch(" + index + ")</td>\n         <td>ground-truth(" + index + ")</td>         <td>sketch("+(index+1)+")</td>\n         <td>ground-truth("+(index+1)+")</td></tr>");
                        index = index + 2;
                    }
                }
                counter++;
            }

            output.innerHTML = "              <table>\n        <tr>\n" + result_array.join("\n") + "        </tr>\n      </table>";
        }
    })


}
