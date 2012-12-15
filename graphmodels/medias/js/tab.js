function switchTab(ProTag, ProBox) {
    for (i = 1; i < 5; i++) {
        if ("tab" + i == ProTag) {
            document.getElementById(ProTag).getElementsByTagName("a")[0].className = "on";
        } else {
            document.getElementById("tab" + i).getElementsByTagName("a")[0].className = "";
        }
        if ("con" + i == ProBox) {
            document.getElementById(ProBox).style.display = "";
        } else {
            document.getElementById("con" + i).style.display = "none";
        }
    }
}

function switchVisTab(ProTag, ProBox) {
    var tabs = new Array("degree_tab", "graph_tab", "icov_tab");
    var viss = new Array("degree_vis", "graph_vis", "icov_vis");

    for (i = 0; i < 3; i++) {
        if (tabs[i] == ProTag) {
            document.getElementById(ProTag).getElementsByTagName("a")[0].className = "on";
        } else {
            document.getElementById(tabs[i]).getElementsByTagName("a")[0].className = "";
        }
        if (viss[i] == ProBox) {
            document.getElementById(ProBox).style.display = "";
        } else {
            document.getElementById(viss[i]).style.display = "none";
        }
    }
}

function warning(status) {
  if (status == 'processed') {
    return true;
  }
  else {
    if (status == 'failed') {
      message = "Failed to complete this task.";
    } else {
      message = "The task has not been processed yet.";
    }
    alert(message);
    return false;
  }
}

function onClickDiv(divId) {
  if (document.getElementById(divId).style.display == 'none') {
    document.getElementById(divId).style.display = '';
  } else {
    document.getElementById(divId).style.display = 'none';
  }
  return 0;
}

function onClickDiv2(divId, srcId) {
  if (document.getElementById(divId).style.display == 'none') {
    document.getElementById(divId).style.display = '';
    document.getElementById(srcId).src = '/images/arrow_down.gif'
  } else {
    document.getElementById(divId).style.display = 'none';
    document.getElementById(srcId).src = '/images/arrow_right.gif'
  }

  return 0;
}
