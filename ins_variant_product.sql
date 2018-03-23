<<<<<<< HEAD
INSERT INTO public.product (manufacturer_id, cat_sub_assoc_id,product_model_number,product_hash,type,name,base_name,upc,depth,height,width,diameter,shipping_weight,unit_of_measure, uom_measurement,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,variant_group,created_at,created_by)
SELECT a.mfg_id,cs.id, a.model_no,a.product_hash,a.item_type,a.name,a.base_name,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.selling_unit,a.uom_measurement,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,a.groups,current_timestamp,1
FROM loading.akeneo a,public.cat_sub_assoc cs, public.sub_category s
WHERE a.item_type = 'item_type_variant' and a.variant_base_prod = 1 and s.sub_category_name = a.atero_cat2 and s.id = cs.sub_category_id 
ON CONFLICT (product_hash) DO UPDATE
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,unit_of_measure=EXCLUDED.unit_of_measure,uom_measurement=EXCLUDED.uom_measurement,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,variant_group=EXCLUDED.variant_group,updated_at=current_timestamp,updated_by=1,deleted_at=NULL,deleted_by=NULL;

create temporary table tmp_hash AS (select p.id , p.variant_group from loading.akeneo a, public.product p where a.groups = p.variant_group and a.variant_base_prod = 1); 

INSERT INTO public.variant_product (product_id,product_model_number,product_hash,name,upc,depth,height,width,diameter,shipping_weight,unit_of_measure, uom_measurement,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,created_at,created_by)
SELECT h.id,a.model_no,a.product_hash,a.name,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.selling_unit,a.uom_measurement,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,current_timestamp,1
FROM loading.akeneo a, tmp_hash h
WHERE a.item_type = 'item_type_variant' and a.groups = h.variant_group 
ON CONFLICT (product_hash) DO UPDATE
SET name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,unit_of_measure=EXCLUDED.unit_of_measure,uom_measurement=EXCLUDED.uom_measurement,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,updated_at=current_timestamp,updated_by=1,deleted_at=NULL,deleted_by=NULL;
=======
INSERT INTO public.variant_product (product_id,product_model_number,product_hash,name,upc,depth,height,width,diameter,shipping_weight,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,created_at,created_by)

SELECT p.product_id,a.model_no,a.product_hash,a.name,NULL,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,current_timestamp,1
FROM loading.akeneo a, public.product p
WHERE a.item_type = 'item_type_variant',  and a.product_hash = p.product_hash and a.base<>'Y'
ON CONFLICT (product_hash) DO UPDATE
SET name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,updated_at=current_timestamp,updated_by=1;
>>>>>>> 2bf7a72d38b355222031dbbc9e93e7587d0ab957
