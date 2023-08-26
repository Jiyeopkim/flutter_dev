import json
import os
from types import SimpleNamespace
import flet as ft
import openai
import sqlite3

openai.api_key = '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'

# sql table을 만든다.
def create_tb(tableName: str):
    conn = sqlite3.connect('./assets/sql.db3')
    conn.execute(f'''
CREATE TABLE "{tableName}" (
	"id"	INTEGER,
	"title"	TEXT,
	"syntax"	REAL,
	"simple_eng"	TEXT,
	"simple_kor"	TEXT,
	"explain_kor"	TEXT,
	"explain_eng"	TEXT,
	"example"	TEXT,
	"category"	INTEGER,
	"tip"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
    ''')
    conn.commit()
    conn.close()

# sql table을 지운다.
def delete_tb(tableName: str):
    conn = sqlite3.connect('./assets/sql.db3')
    conn.execute(f'DROP TABLE "{tableName}"')
    conn.commit()
    conn.close()

# sql table에 레코드를 추가한다.
def insert_db(tableName: str, index: int, title: str, syntax: str, simple_eng: str, simple_kor: str, explain_eng: str, explain_kor: str, example: str):
    conn = sqlite3.connect('./assets/sql.db3')
    cur = conn.cursor()
    conn.execute(f'INSERT INTO {tableName} (id, title, syntax, simple_eng, simple_kor, explain_eng, explain_kor, example) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', 
                (index, title, syntax, simple_eng, simple_kor, explain_eng, explain_kor, example)) 
    conn.commit()
    conn.close()    

def main(page: ft.Page):
    page.title = "Learn SQL"
    page.vertical_alignment = ft.MainAxisAlignment.START
    page.window_left = 0
    page.window_top = 0
    page.window_width = 600
    page.window_height = 1024

    txt_number = ft.TextField(value="0", text_align=ft.TextAlign.RIGHT, width=100)
    txt_result = ft.Text("Result")
    txt_progress = ft.Text("Progress...")
    txt_error = ft.Text("error", color=ft.colors.ERROR)
    pr = ft.ProgressRing(width=16, height=16, stroke_width = 2)
    pr.visible = False

    def check_item_clicked(e):
        e.control.checked = not e.control.checked
        page.update()

    # app bar
    page.appbar = ft.AppBar(
        leading=ft.Icon(ft.icons.PALETTE),
        leading_width=40,
        title=ft.Text("AppBar Example"),
        center_title=False,
        bgcolor=ft.colors.SURFACE_VARIANT,
        actions=[
            ft.IconButton(ft.icons.WB_SUNNY_OUTLINED),
            ft.IconButton(ft.icons.FILTER_3),
            ft.PopupMenuButton(
                items=[
                    ft.PopupMenuItem(text="Item 1"),
                    ft.PopupMenuItem(),  # divider
                    ft.PopupMenuItem(
                        text="Checked item", checked=False, on_click=check_item_clicked
                    ),
                ]
            ),
        ],
    )

    # navigation bar
    page.navigation_bar = ft.NavigationBar(
        destinations=[
            ft.NavigationDestination(icon=ft.icons.EXPLORE, label="Explore"),
            ft.NavigationDestination(icon=ft.icons.COMMUTE, label="Commute"),
            ft.NavigationDestination(
                icon=ft.icons.BOOKMARK_BORDER,
                selected_icon=ft.icons.BOOKMARK,
                label="Explore",
            ),
        ]
    )

    def insert_lesson_all(e):
        txt_progress.visible = True
        txt_number.value = str(int(txt_number.value) + 1)
        pr.visible = True
        page.update()

        index = 1

        # lesson.txt 파일을 연다.
        f = open('./python/lesson.txt', 'r')

        # lesson.txt 파일의 내용을 처음부터 끝까지 한줄씩 읽어오는 반목문을 실행한다.
        while True:
            if txt_progress.visible == False:
                pr.visible = False
                page.update()
                break

            line = f.readline()
            if not line: break
            print(line)
            line = line.replace('\n', '')
            print(f'{index}, {line}')
            insert_lesson(index, line)
            index += 1

        txt_progress.visible = False
        page.update()

    def create_lesson_table(e):
        create_tb('lesson')     

    def delete_lesson_table(e):
        delete_tb('lesson')   

    def cancel_lesson_all(e):
        txt_progress.visible = False
    # body
    page.add(
        ft.Column(
            [
                ft.Text("Gathering"),
                txt_progress,
                ft.Row(
                    [
                        ft.OutlinedButton(text="create lesson table", on_click=create_lesson_table),
                        ft.OutlinedButton(text="delete lesson table", on_click=delete_lesson_table),
                        ft.OutlinedButton(text="insert lesson table", on_click=insert_lesson_all),  
                        ft.OutlinedButton(text="cancel", on_click=cancel_lesson_all),                       
                    ]
                ),
                pr,
                txt_number,
                txt_result,
                txt_error
            ],
            alignment=ft.MainAxisAlignment.START,
            horizontal_alignment=ft.CrossAxisAlignment.START,
        )
    )
    # chatbot을 통해 sql 레슨을 생성한다.
    def insert_lesson(index: int, sqlStatement: str):
        pr.visible = True
        txt_number.value = str(index)
        page.update()

#         prompt = f'''
# 다음 """{sqlStatement}""" SQL 명령문의 설명을 다음과 같이 작성해줘.
# 먼저 SQL 명령문의 문법을 설명해줘.
# 그 다음 간단한 설명을 영어 한 문장으로 설명하고,
# 그 다음 한국어로 설명해줘.
# 그 다음 한문단 길이의 영어로 설명하고,
# 그 다음 한문단 길이의 한국어로 설명해줘.
# 마지막으로 SQL 예제를 하나 작성해줘.
# 대답은 json 형식으로 다음과 같이 작성하고 내용이 없으면 빈칸으로 두면 됨.
# [syntax], [simple_eng] : [simple_kor] : [expain_eng] : [explain_kor] : [example]
#         '''

#         prompt = f'''
# this SQL statement """{sqlStatement}"""": Write a description of the SQL statement as follows.
# First, the syntax of the SQL statement.
# Then give a brief explanation in one sentence in English,
# then explain it in Korean.
# Then a one-paragraph explanation in English,
# then a paragraph-long explanation in Korean.
# Finally, write an SQL example.
# Your answer should be written in exact JSON format only as follows (leaving key value blank if they don't exist).
# {{[sql_syntax] : [simple_eng] : [simple_kor] : [expain_eng] : [explain_kor] : [example]}}
#        '''        

        prompt = f'''
this SQL statement """{sqlStatement}"""": Write a description of the SQL statement as follows. 
{{
    "sql_syntax": "the syntax of the SQL statement",
    "simple_eng": "give a brief explanation in one sentence in English",
    "simple_kor": "give a brief explanation in one sentence in Korean",
    "explain_eng": "a one-paragraph explanation in English",
    "explain_kor": "a one-paragraph explanation in Korean",
    "example": " write an SQL example"
}}
you should answer in exact JSON format only as follows (leaving key value blank if they don't exist).
        '''

        response = openai.ChatCompletion.create(
            # model="gpt-3.5-turbo",
            model="gpt-4",
            messages=[
                    {"role": "system", "content": "You are teaching SQL for beginer."},
                    {"role": "user", "content": prompt}
                ]
            )
            
        data = response['choices'][0]['message']['content']
        txt_result.value = data
        page.update()

        # Parse JSON into an object with attributes corresponding to dict keys.
        try:
            x = json.loads(data, object_hook=lambda d: SimpleNamespace(**d))
            # print(x.syntax, x.simple_eng, x.simple_kor, x.explain_eng, x.explain_kor, x.example)
            insert_db('lesson', index, sqlStatement, x.sql_syntax, x.simple_eng, x.simple_kor, x.explain_eng, x.explain_kor, x.example)
        except Exception as e:    # 모든 예외의 에러 메시지를 출력할 때는 Exception을 사용
            print('예외 발생.', e)
            txt_error.value = f'error: {index}, {e}'
            pr.visible = False
            page.update()
            return
        


        pr.visible = False
        page.update()

ft.app(target=main)

