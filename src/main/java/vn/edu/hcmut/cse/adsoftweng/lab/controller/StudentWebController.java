package vn.edu.hcmut.cse.adsoftweng.lab.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmut.cse.adsoftweng.lab.service.StudentService;
import vn.edu.hcmut.cse.adsoftweng.lab.entity.Student;

import java.util.List;

@Controller
@RequestMapping("/students")
public class StudentWebController {

	@Autowired
	private StudentService service;

	@GetMapping
	public String getAllStudents(@RequestParam(required = false) String keyword, Model model) {
		List<Student> students;
		if (keyword != null && !keyword.isEmpty()) {
			students = service.searchByName(keyword);
		} else {
			students = service.getAll();
		}
		model.addAttribute("dsSinhVien", students);
		model.addAttribute("keyword", keyword);
		return "students";
	}

	@GetMapping("/{id}")
	public String getStudentDetail(@PathVariable String id, Model model) {
		Student student = service.getById(id);
		if (student == null) {
			return "redirect:/students";
		}
		model.addAttribute("student", student);
		return "student-detail";
	}

	@GetMapping("/new")
	public String showAddForm(Model model) {
		model.addAttribute("student", new Student());
		model.addAttribute("isEdit", false);
		return "student-form";
	}

	@GetMapping("/{id}/edit")
	public String showEditForm(@PathVariable String id, Model model) {
		Student student = service.getById(id);
		if (student == null) {
			return "redirect:/students";
		}
		model.addAttribute("student", student);
		model.addAttribute("isEdit", true);
		return "student-form";
	}

	@PostMapping
	public String createStudent(@ModelAttribute Student student) {
		service.create(student);
		return "redirect:/students";
	}

	@PostMapping("/{id}")
	public String updateStudent(@PathVariable String id, @ModelAttribute Student student) {
		service.update(id, student);
		return "redirect:/students";
	}

	@PostMapping("/{id}/delete")
	public String deleteStudent(@PathVariable String id) {
		service.delete(id);
		return "redirect:/students";
	}
}
