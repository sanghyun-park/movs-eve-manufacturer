# Moving Star's manufacturer supporting tool
EVE Online Moving Star corporation manufacturer supporting tool

## Supported APIs
### Blueprint
URL: /api/blueprints/<typeid>

e.g.,
* Request URL : http://manufacturer.movingstar.org/api/blueprints/682
* Result :
```
<?xml version="1.0" encoding="UTF-8"?>
<blueprint>
	<activities>
		<copying>
			<time>480</time>
		</copying>
		<manufacturing>
			<materials>
				<quantity>133</quantity>
				<typeID>38</typeID>
			</materials>
			<products>
				<quantity>1</quantity>
				<typeID>166</typeID>
			</products>
			<time>600</time>
		</manufacturing>
		<research_material>
			<time>210</time>
		</research_material>
		<research_time>
			<time>210</time>
		</research_time>
	</activities>
	<blueprintTypeID>682</blueprintTypeID>
	<maxProductionLimit>300</maxProductionLimit>
</blueprint>
```
