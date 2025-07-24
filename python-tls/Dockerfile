FROM reg.mini.dev/python:latest-dev AS builder
WORKDIR /app
RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"
RUN pip install flask

FROM reg.mini.dev/python:latest
WORKDIR /app
COPY --from=builder /app/venv /app/venv
COPY app.py .
ENV PATH="/app/venv/bin:$PATH"
CMD ["python", "app.py"]
