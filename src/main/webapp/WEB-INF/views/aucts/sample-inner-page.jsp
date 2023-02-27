<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!DOCTYPE html>
<body>

	<!-- ======= Header ======= -->
	<%@ include file="/WEB-INF/views/include/header.jsp"%>
	<!-- End Header -->

	<main id="main">

		<!-- ======= Breadcrumbs ======= -->
		<div class="breadcrumbs">
			<div class="page-header d-flex align-items-center"
				style="background-image: url('/web/images/page-header.jpg');">
				<div class="container position-relative">
					<div class="row d-flex justify-content-center">
						<div class="col-lg-6 text-center">
							<h2>Sample Inner Page</h2>
							<p>Odio et unde deleniti. Deserunt numquam exercitationem.
								Officiis quo odio sint voluptas consequatur ut a odio
								voluptatem. Sit dolorum debitis veritatis natus dolores. Quasi
								ratione sint. Sit quaerat ipsum dolorem.</p>
						</div>
					</div>
				</div>
			</div>
			<nav>
				<div class="container">
					<ol>
						<li><a href="index">Home</a></li>
						<li>Sample Inner Page</li>
					</ol>
				</div>
			</nav>
		</div>
		<!-- End Breadcrumbs -->

		<section class="sample-page">
			<div class="container" data-aos="fade-up">
				<p>You can duplicate this sample page and create any number of
					inner pages you like!</p>
			</div>
		</section>

	</main>
	<!-- End #main -->

	<!-- ======= Footer ======= -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<!-- End Footer -->
</html>