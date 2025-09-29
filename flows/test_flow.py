from prefect import flow, task
from datetime import datetime

@task
def get_current_time():
    now = datetime.now()
    print(f"Current time is: {now}")
    return now

@task
def square_number(x: int):
    result = x * x
    print(f"Square of {x} is {result}")
    return result

@flow(name="test_flow")
def test_flow():
    time_now = get_current_time()
    square = square_number(5)
    print(f"Flow finished at {time_now}, square result: {square}")

if __name__ == "__main__":
    test_flow()
