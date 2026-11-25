import subprocess, os, glob
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
BASE = os.path.dirname(os.path.abspath(__file__))
order = ["login","dashboard","project-list","demand-list","intent-list","receiving","batch-list",
         "application-list","application-review","distribute","distribution-list","distribution-detail",
         "feedback-list","rule-config","score-detail","report","user-list","role-list","menu-list",
         "log-list","message","profile","portal","volunteer","applicant"]
for i, name in enumerate(order, 1):
    src = os.path.join(BASE, name + ".html")
    out = os.path.join(BASE, "pages", "%02d_%s.png" % (i, name))
    subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars",
                    "--force-device-scale-factor=1", "--window-size=1440,900",
                    "--screenshot=" + out, "file://" + src],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print("%02d %s %s" % (i, name, "ok" if os.path.exists(out) else "FAIL"))
