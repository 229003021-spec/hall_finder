import sys
import os

# Detect if executed within Streamlit environment
is_streamlit = False
try:
    import streamlit as st
    from streamlit.runtime.scriptrunner import get_script_run_ctx
    if get_script_run_ctx() is not None or any("streamlit" in arg.lower() for arg in sys.argv):
        is_streamlit = True
except Exception:
    if any("streamlit" in arg.lower() for arg in sys.argv):
        is_streamlit = True

if is_streamlit:
    import streamlit.components.v1 as components

    st.set_page_config(
        page_title="Hall Finder · SASTRA DEEMED UNIVERSITY",
        page_icon="🏫",
        layout="wide",
        initial_sidebar_state="collapsed",
    )

    st.markdown("""
        <style>
            #MainMenu {visibility: hidden;}
            footer {visibility: hidden;}
            header {visibility: hidden;}
            .block-container {
                padding: 0rem !important;
                margin: 0rem !important;
                max-width: 100% !important;
            }
            iframe {
                width: 100% !important;
                height: 95vh !important;
                border: none !important;
            }
        </style>
    """, unsafe_allow_html=True)

    html_path = os.path.join(os.path.dirname(__file__), "index.html")
    if not os.path.exists(html_path):
        html_path = os.path.join(os.path.dirname(__file__), "web", "index.html")

    if os.path.exists(html_path):
        with open(html_path, "r", encoding="utf-8") as f:
            html_code = f.read()
        components.html(html_code, height=950, scrolling=True)
    else:
        st.error("index.html not found.")
else:
    import http.server
    import socketserver
    import webbrowser

    PORT = 8000
    DIRECTORY = os.path.dirname(__file__)

    class Handler(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=DIRECTORY, **kwargs)

    if __name__ == "__main__":
        if hasattr(sys.stdout, 'reconfigure'):
            sys.stdout.reconfigure(encoding='utf-8')
        try:
            with socketserver.TCPServer(("", PORT), Handler) as httpd:
                print(f"Hall Finder Web App running at http://localhost:{PORT}")
                webbrowser.open(f"http://localhost:{PORT}")
                httpd.serve_forever()
        except Exception as e:
            print(f"Server error: {e}")
