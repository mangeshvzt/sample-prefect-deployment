# from prefect import flow, task

# @task
# def say_hello(name: str):
#     print(f"Hello, {name}!")

# @flow(name="hello-world-flow")
# def hello_flow():
#     say_hello("World")


from prefect import flow, task

@task
def say_hello(name: str):
    print(f"Hello, {name}!")

@flow(name="hello-world-flow")
def hello_flow():
    say_hello("World")
