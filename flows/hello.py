# from prefect import flow, task

# @task
# def say_hello(name: str):
#     print(f"Hello, {name}!")

# @flow(name="hello-world-flow")
# def hello_flow():
#     say_hello("World")


# flows/hello_world.py
from prefect import flow
from prefect.deployments import Deployment

@flow
def hello_flow():
    print("Hello Prefect 3.4!")

# Optionally define a deployment (can also do it from CLI)
Deployment.build_from_flow(
    flow=hello_flow,
    name="hello-world",
    version="dev"
)
