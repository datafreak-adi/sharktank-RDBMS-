from sqlalchemy import create_engine
import pandas as pd
import streamlit as st
from sqlalchemy import  text

# Define connection string
user = "root"
host = "127.0.0.1"
db = "shark_tank"
port = 3306

def get_connection():
  connection_string = f"mysql+pymysql://{user}@{host}:{port}/{db}"
  engine = create_engine(connection_string)
  return engine
# Use in your Streamlit app

st.title("Invest Clear and Shift the Gear")


  # Dictionary: table => columns (you can add default values too)
TABLE_COLUMNS = {
    "Season": ["Season_Number", "Season_Start", "Season_End"],
    "Episode": ["Episode_Number", "Season_ID", "Original_Air_Date", "Episode_Title", "Anchor"],
    "Pitch": ["Pitch_Number", "Startup_ID", "Episode_ID", "Deal_Status", "Amount_Asked", "Equity_Asked", "Valuation_Asked", "Amount_Raised", "Equity_Given", "Debt"],
    "GuestShark": ["Guest_Name", "Episode_ID", "Season_ID", "Expertise", "Net_worth"],
    "Investment": ["Pitch_ID", "Shark_ID"],
    "Shark": ["Shark_Name", "Net_Worth", "Industry_of_Expertise"],
    "Startup": ["Startup_Name", "Industry", "Founders"]
}

# Sidebar table selector

table_options = ["Hey! Select a table"] + list(TABLE_COLUMNS.keys())

selected_table = st.sidebar.selectbox("Select table to insert/view", table_options)

engine = get_connection()
# Prevent proceeding unless a real table is selected
if selected_table == "Hey! Select a table":

    st.markdown("""
        Welcome to the **Shark Tank Investment Tracker** 📊  
        Use the sidebar to select a database table (e.g., Seasons, Episodes, Pitches)  
        My website allow users to **insert new records** easily, and **view table contents** live on the dashboard.

        This dashboard allows:
        - 📥 Inserting data into normalized MySQL tables  
        - 🔍 Viewing and managing startup pitches, sharks, investments, and episodes 
        > 
        """)
    st.warning("Select a table on the left to begin 🚀")

    # Fixed issue of auto_increment

    AUTO_INCREMENT_TABLES = {
        "Season": "Season_ID",
        "Episode": "Episode_ID",
        "Pitch": "Pitch_ID",
        "GuestShark": "Guest_ID",
        "Investment": "Investment_ID",
        "Shark": "Shark_ID",
        "Startup": "Startup_ID"
    }

    st.sidebar.markdown("### 🔧 Admin Tools")
    if st.sidebar.button("Reset AUTO_INCREMENT"):
        try:
            with engine.begin() as conn:
                for table, id_col in AUTO_INCREMENT_TABLES.items():
                    result = conn.execute(text(f"SELECT MAX({id_col}) FROM {table}"))
                    max_id = result.scalar() or 0
                    next_id = max_id + 1
                    conn.execute(text(f"ALTER TABLE {table} AUTO_INCREMENT = {next_id}"))
            st.sidebar.success(" AUTO_INCREMENT reset for all tables.")
        except Exception as e:
            st.sidebar.error(f"Failed: {e}")

    st.stop()

# Form to insert new data
st.markdown(f"""
<h2 style='text-align: left; color: #000000; font-family: "Segoe UI" '>
 <span style='font-weight:500'>{selected_table}</span>
</h2>
""", unsafe_allow_html=True)


st.markdown(f"<h3>📄 Current Records in {selected_table}</h3>", unsafe_allow_html=True)
try:
    with engine.connect() as conn:
        df = pd.read_sql(f"SELECT * FROM {selected_table}", conn)
        st.dataframe(df)
except Exception as e:
    st.error(f"❌ Could not load data: {e}")


with st.form("form_insert"):
    form_data = {}
    with engine.connect() as conn:
        for col in TABLE_COLUMNS[selected_table]:
            if "Date" in col:
                form_data[col] = st.date_input(col, value="today")
            elif "Status" in col:
                form_data[col] = st.selectbox(col, ["Accepted", "Rejected"])
            elif "ID" in col and col != f"{selected_table}_ID": # Create foriegn key dropdowns
                ref_table = col.replace("_ID", "")
                try:
                    result = conn.execute(text(f"SELECT {col} FROM {ref_table}"))
                    options = [row[0] for row in result.fetchall()]
                    form_data[col] = st.selectbox(col, options)
                except:
                    form_data[col] = st.number_input(col, step=1)
            elif "Amount" in col or "Valuation" in col or "Equity" in col or "Debt" in col or "Net_Worth" in col:
                form_data[col] = st.number_input(col, step=0.01)
            else:
                form_data[col] = st.text_input(col)



    submitted = st.form_submit_button("Insert Record")

    if submitted:
        try:
            with engine.begin() as conn:
                columns = list(form_data.keys())
                cols_string = ", ".join(columns)
                placeholders = ", ".join([f":{col}" for col in columns])
                query = text(f"INSERT INTO {selected_table} ({cols_string}) VALUES ({placeholders})")
                conn.execute(query, form_data)
                st.success(f"Records are successfully inserted into {selected_table}.")

                df = pd.read_sql(f"SELECT * FROM {selected_table}", conn)
                st.markdown(f"<h3> Updated Records in {selected_table}</h3>", unsafe_allow_html=True)
                st.dataframe(df)
        except Exception as e:
            st.error(f"Oops! Insertion failed: {e}")





