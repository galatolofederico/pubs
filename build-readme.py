import argparse
import csv
import datetime

parser = argparse.ArgumentParser()

parser.add_argument("--publications", type=str, default="publications.csv")
parser.add_argument("--output", type=str, default="README.md")
parser.add_argument("--base-pdf-link", type=str, default="https://pubs.galatolo.me")

args = parser.parse_args()

pubs = []
with open(args.publications, newline="\n") as csvfile:
    rows = csv.reader(csvfile, delimiter=",")
    for row in rows:
        if len(row) != 3:
            continue
        title, date, pdf = row
        if title == "title":
            continue
        date = datetime.datetime.strptime(date, "%Y:%m:%d %H:%M:%S%z")
        pubs.append(dict(
            title=title,
            date=date,
            pdf=pdf,
        ))

pubs.sort(key=lambda x: x["date"], reverse=True)
years = []

with open(args.output, "w") as f:
    f.write("# Publications\n")
    for pub in pubs:
        year = pub["date"].year
        if year not in years:
            years.append(year)
            f.write(f"## {year}\n")
        pdf_name = pub["pdf"].split("/")[-1]
        pdf_link = f"{args.base_pdf_link}/{pdf_name}"
        f.write(f"- [{pub['title']}]({pdf_link})\n")
