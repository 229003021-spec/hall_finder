import streamlit as st
import streamlit.components.v1 as components
import os

st.set_page_config(
    page_title="Hall Finder · SASTRA DEEMED UNIVERSITY",
    page_icon="🏫",
    layout="wide",
    initial_sidebar_state="collapsed",
)

# Custom CSS to maximize Streamlit viewport
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

# Load index.html
html_path = os.path.join(os.path.dirname(__file__), "index.html")

if os.path.exists(html_path):
    with open(html_path, "r", encoding="utf-8") as f:
        html_code = f.read()
    components.html(html_code, height=950, scrolling=True)
else:
    st.error("index.html not found.")
