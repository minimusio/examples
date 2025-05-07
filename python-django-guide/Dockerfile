FROM reg.mini.dev/python:3-dev 
EXPOSE 8000
WORKDIR /myapp 
COPY requirements.txt /myapp/
RUN pip3 install -r requirements.txt --no-cache-dir
COPY src/ /myapp/
ENTRYPOINT ["python3"] 
CMD ["manage.py", "runserver", "0.0.0.0:8000"]

