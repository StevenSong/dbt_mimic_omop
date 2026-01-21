Welcome to your new dbt project!

http://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/
```
wget -P data/mimic/annotations \
     -O data/mimic/annotations/discharge_annotations.csv.gz \
     https://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/discharge_annotations.csv.gz
```

```
wget -P data/mimic/annotations \
     -O data/mimic/annotations/radiology_annotations.csv.gz \
     https://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/radiology_annotations.csv.gz
```
### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
